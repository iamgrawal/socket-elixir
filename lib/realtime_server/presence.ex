defmodule RealtimeServer.Presence do
  use Phoenix.Presence,
    otp_app: :realtime_server,
    pubsub_server: RealtimeServer.PubSub

  alias RealtimeServer.Presence
  require Logger

  def track_user_device(user_id, device_id) do
    topic = "presence:#{user_id}"
    
    case list(topic) do
      devices when map_size(devices) >= 1 ->
        Logger.warn("User #{user_id} attempted to connect with multiple devices")
        {:error, :device_limit_reached}
      _ ->
        track(self(), topic, device_id, %{
          online_at: System.system_time(:second),
          device_id: device_id
        })
    end
  end

  def list_online_users do
    Presence.list("presence:lobby")
    |> Map.keys()
  end

  def user_online?(user_id) do
    topic = "presence:#{user_id}"
    case list(topic) do
      presence when map_size(presence) > 0 -> true
      _ -> false
    end
  end

  def handle_diff(diff, state) do
    for {user_id, {joins, leaves}} <- diff do
      for {key, meta} <- joins do
        Logger.debug("#{user_id} joined #{key} with #{inspect(meta)}")
      end

      for {key, meta} <- leaves do
        Logger.debug("#{user_id} left #{key} with #{inspect(meta)}")
      end
    end

    {:ok, state}
  end
end 