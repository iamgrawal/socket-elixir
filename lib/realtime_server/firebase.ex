defmodule RealtimeServer.Firebase do
  @moduledoc """
  Handles Firebase integration for real-time features.
  Uses Firebase Admin SDK for server-side operations.
  """

  require Logger

  @doc """
  Pushes a new comment to Firebase
  """
  def push_comment(%{id: id, content: content, video_id: video_id, user: user} = comment) do
    path = "comments/#{video_id}/#{id}"
    data = %{
      id: id,
      content: content,
      user: %{
        id: user.id,
        username: user.username
      },
      created_at: DateTime.to_iso8601(comment.inserted_at)
    }

    case write_firebase_data(path, data) do
      {:ok, _} -> 
        Logger.info("Successfully pushed comment #{id} to Firebase")
        {:ok, comment}
      
      {:error, reason} = error ->
        Logger.error("Failed to push comment #{id} to Firebase: #{inspect(reason)}")
        error
    end
  end

  @doc """
  Removes a comment from Firebase
  """
  def delete_comment(video_id, comment_id) do
    path = "comments/#{video_id}/#{comment_id}"

    case delete_firebase_data(path) do
      {:ok, _} -> 
        Logger.info("Successfully deleted comment #{comment_id} from Firebase")
        :ok
      
      {:error, reason} = error ->
        Logger.error("Failed to delete comment #{comment_id} from Firebase: #{inspect(reason)}")
        error
    end
  end

  @doc """
  Updates user presence in Firebase
  """
  def update_presence(video_id, user_id, status) do
    path = "presence/#{video_id}/#{user_id}"
    data = %{
      online: status,
      last_seen: DateTime.utc_now() |> DateTime.to_iso8601()
    }

    case write_firebase_data(path, data) do
      {:ok, _} -> 
        Logger.info("Successfully updated presence for user #{user_id} in video #{video_id}")
        :ok
      
      {:error, reason} = error ->
        Logger.error("Failed to update presence: #{inspect(reason)}")
        error
    end
  end

  # Private functions

  defp write_firebase_data(path, data) do
    # Implementation depends on the Firebase Admin SDK library being used
    # This is a placeholder for the actual implementation
    {:ok, data}
  end

  defp delete_firebase_data(path) do
    # Implementation depends on the Firebase Admin SDK library being used
    # This is a placeholder for the actual implementation
    {:ok, nil}
  end

  defp get_firebase_token do
    # Implementation for getting/refreshing Firebase Admin SDK token
    # This is a placeholder for the actual implementation
    {:ok, "firebase_token"}
  end
end 