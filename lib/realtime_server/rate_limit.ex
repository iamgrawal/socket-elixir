defmodule RealtimeServer.RateLimit do
  @moduledoc """
  Handles rate limiting for various actions in the application.
  Uses Redis for distributed rate limiting across multiple nodes.
  """

  require Logger
  alias Redix.Command

  @default_limit 30
  @default_window_seconds 60

  @doc """
  Checks if the given action for a user is within rate limits.
  
  ## Parameters
  
    * user_id - The ID of the user performing the action
    * action - The type of action being performed (e.g., "new_comment")
    * opts - Optional configuration for rate limiting
      * limit: Maximum number of actions in the window (default: 30)
      * window_seconds: Time window in seconds (default: 60)
  
  ## Examples
  
      iex> RateLimit.check_rate("user123", "new_comment")
      :ok
  
      iex> RateLimit.check_rate("user123", "new_comment", limit: 5)
      {:error, :rate_limit_exceeded}
  """
  def check_rate(user_id, action, opts \\ []) do
    limit = Keyword.get(opts, :limit, @default_limit)
    window = Keyword.get(opts, :window_seconds, @default_window_seconds)
    
    key = rate_limit_key(user_id, action)
    count = increment_and_get(key, window)

    if count > limit do
      Logger.warn("Rate limit exceeded for user #{user_id} on action #{action}")
      {:error, :rate_limit_exceeded}
    else
      :ok
    end
  end

  @doc """
  Gets the current rate limit status for a user and action.

  ## Examples

      iex> RateLimit.get_limit_status("user123", "new_comment")
      {:ok, %{count: 5, limit: 30, remaining: 25, reset_in: 45}}
  """
  def get_limit_status(user_id, action) do
    key = rate_limit_key(user_id, action)
    
    with {:ok, count} <- get_current_count(key),
         {:ok, ttl} <- get_ttl(key) do
      {:ok, %{
        count: count,
        limit: @default_limit,
        remaining: max(0, @default_limit - count),
        reset_in: ttl
      }}
    end
  end

  # Private Functions

  defp rate_limit_key(user_id, action) do
    "rate_limit:#{action}:#{user_id}"
  end

  defp increment_and_get(key, window) do
    {:ok, conn} = Redix.start_link()
    
    try do
      case Redix.pipeline(conn, [
        ["INCR", key],
        ["EXPIRE", key, window]
      ]) do
        {:ok, [count, _]} -> count
        _ -> 0
      end
    after
      Redix.stop(conn)
    end
  end

  defp get_current_count(key) do
    {:ok, conn} = Redix.start_link()
    
    try do
      case Redix.command(conn, ["GET", key]) do
        {:ok, nil} -> {:ok, 0}
        {:ok, count} -> {:ok, String.to_integer(count)}
        error -> error
      end
    after
      Redix.stop(conn)
    end
  end

  defp get_ttl(key) do
    {:ok, conn} = Redix.start_link()
    
    try do
      case Redix.command(conn, ["TTL", key]) do
        {:ok, -2} -> {:ok, 0}  # Key doesn't exist
        {:ok, -1} -> {:ok, 0}  # Key exists but has no expiry
        {:ok, ttl} -> {:ok, ttl}
        error -> error
      end
    after
      Redix.stop(conn)
    end
  end
end 