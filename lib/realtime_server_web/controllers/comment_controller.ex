defmodule RealtimeServerWeb.CommentController do
  use RealtimeServerWeb, :controller

  alias RealtimeServer.Comments
  alias RealtimeServer.Comments.Comment

  action_fallback RealtimeServerWeb.FallbackController

  @doc """
  Lists comments for a video with pagination
  """
  def index(conn, %{"video_id" => video_id} = params) do
    page = Map.get(params, "page", 1)
    per_page = Map.get(params, "per_page", 50)
    
    comments = Comments.list_comments(video_id, limit: per_page, offset: (page - 1) * per_page)
    
    conn
    |> put_status(:ok)
    |> render("index.json", comments: comments)
  end

  @doc """
  Creates a new comment
  """
  def create(conn, %{"comment" => comment_params}) do
    user = Guardian.Plug.current_resource(conn)
    
    with {:ok, :allowed} <- check_rate_limit(user.id),
         {:ok, %Comment{} = comment} <- Comments.create_comment(Map.put(comment_params, "user_id", user.id)) do
      
      # Sync with Firebase in background
      Task.start(fn -> 
        RealtimeServer.Firebase.push_comment(comment)
      end)

      conn
      |> put_status(:created)
      |> render("show.json", comment: comment)
    end
  end

  @doc """
  Shows a specific comment
  """
  def show(conn, %{"id" => id}) do
    with {:ok, comment} <- Comments.get_comment(id) do
      render(conn, "show.json", comment: comment)
    end
  end

  @doc """
  Deletes a comment
  """
  def delete(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    
    with {:ok, comment} <- Comments.get_comment(id),
         :ok <- authorize_delete(user, comment),
         {:ok, %Comment{}} <- Comments.delete_comment(comment) do
      
      send_resp(conn, :no_content, "")
    end
  end

  # Private functions

  defp check_rate_limit(user_id) do
    case RealtimeServer.RateLimit.check_rate(user_id, "new_comment") do
      :ok -> {:ok, :allowed}
      {:error, :rate_limit_exceeded} = error -> error
    end
  end

  defp authorize_delete(user, comment) do
    if user.id == comment.user_id do
      :ok
    else
      {:error, :unauthorized}
    end
  end
end 