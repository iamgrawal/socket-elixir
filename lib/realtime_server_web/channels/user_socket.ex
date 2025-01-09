defmodule RealtimeServerWeb.UserSocket do
  use Phoenix.Socket
  require Logger

  ## Channels
  channel "comments:*", RealtimeServerWeb.CommentChannel
  channel "chat:*", RealtimeServerWeb.ChatChannel
  channel "presence:*", RealtimeServerWeb.PresenceChannel

  @impl true
  def connect(%{"token" => token}, socket, _connect_info) do
    case RealtimeServer.Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        {:ok, assign(socket, :user_id, claims["sub"])}
      {:error, reason} ->
        Logger.error("Failed to authenticate socket connection: #{inspect(reason)}")
        :error
    end
  end

  def connect(_, _socket, _connect_info) do
    Logger.error("Socket connection attempted without token")
    :error
  end

  @impl true
  def id(socket), do: "user_socket:#{socket.assigns.user_id}"
end 