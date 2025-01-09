defmodule RealtimeServerWeb.CommentChannel do
  use Phoenix.Channel
  require Logger
  alias RealtimeServer.Comments
  alias RealtimeServer.Presence

  @impl true
  def join("comments:" <> video_id, _params, socket) do
    if authorized?(socket, video_id) do
      send(self(), :after_join)
      {:ok, assign(socket, :video_id, video_id)}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_info(:after_join, socket) do
    {:ok, _} = Presence.track(socket, socket.assigns.user_id, %{
      online_at: inspect(System.system_time(:second))
    })
    
    push(socket, "presence_state", Presence.list(socket))
    {:noreply, socket}
  end

  @impl true
  def handle_in("new_comment", %{"content" => content}, socket) do
    user_id = socket.assigns.user_id
    video_id = socket.assigns.video_id

    with {:ok, :allowed} <- check_rate_limit(user_id),
         {:ok, comment} <- Comments.create_comment(%{
           content: content,
           video_id: video_id,
           user_id: user_id
         }) do
       
      Task.start(fn -> 
        RealtimeServer.Firebase.push_comment(comment)
      end)

      broadcast!(socket, "new_comment", %{
        id: comment.id,
        content: comment.content,
        user_id: comment.user_id,
        inserted_at: comment.inserted_at
      })

      {:reply, :ok, socket}
    else
      {:error, :rate_limit_exceeded} ->
        {:reply, {:error, %{reason: "rate limit exceeded"}}, socket}
      {:error, changeset} ->
        Logger.error("Failed to create comment: #{inspect(changeset)}")
        {:reply, {:error, %{reason: "Failed to create comment"}}, socket}
    end
  end

  @impl true
  def handle_in("delete_comment", %{"comment_id" => comment_id}, socket) do
    with {:ok, comment} <- Comments.get_comment(comment_id),
         :ok <- authorize_delete(socket, comment),
         {:ok, _} <- Comments.delete_comment(comment) do
      broadcast!(socket, "comment_deleted", %{id: comment_id})
      {:reply, :ok, socket}
    else
      {:error, reason} ->
        {:reply, {:error, %{reason: reason}}, socket}
    end
  end

  defp authorized?(socket, video_id) do
    # Add your authorization logic here
    # For example, check if the user has access to the video
    true
  end

  defp authorize_delete(socket, comment) do
    if socket.assigns.user_id == comment.user_id do
      :ok
    else
      {:error, :unauthorized}
    end
  end

  defp check_rate_limit(user_id) do
    case RealtimeServer.RateLimit.check_rate(user_id, "new_comment") do
      :ok -> {:ok, :allowed}
      {:error, :rate_limit_exceeded} = error -> error
    end
  end
end 