# Real-time Features

## Overview

The Realtime Server provides WebSocket-based real-time communication using Phoenix Channels. Our implementation includes:

- Real-time comments system
- User presence tracking
- Device management
- Firebase synchronization

## Channel Types

### 1. Comment Channel

Handles real-time comments for videos with Firebase synchronization.

```elixir
defmodule RealtimeServerWeb.CommentChannel do
  use Phoenix.Channel
  alias RealtimeServer.Comments
  alias RealtimeServer.Presence
  def join("comments:" <> video_id, \_params, socket) do
      send(self(), :after_join)
      {:ok, assign(socket, :video_id, video_id)}
  end
end
```

#### Client Usage

```javascript
// Join comment channel
const channel = socket.channel(`comments:${videoId}`, {});
channel.join().receive("ok", (response) => {
  console.log("Joined comment channel", response);
});
// Send new comment
channel
  .push("new_comment", { content: "Great video!" })
  .receive("ok", (response) => {
    console.log("Comment sent", response);
  });
```

### 2. Presence Channel

Manages user presence and device tracking.

```elixir

defmodule RealtimeServer.Presence do
  use Phoenix.Presence,
      otp_app: :realtime_server,
      pubsub_server: RealtimeServer.PubSub
  def track_user_device(user_id, device_id) do
      topic = "presence:#{user_id}"
      case list(topic) do
        devices when map_size(devices) >= 1 ->
          {:error, :device_limit_reached}
        _ ->
          track(self(), topic, device_id, %{
            online_at: System.system_time(:second)
          })
      end
  end
end
```

#### Client Implementation

```javascript
// Track presence changes
channel.on("presence_state", (state) => {
  console.log("Initial presence state", state);
});

channel.on("presence_diff", (diff) => {
  console.log("Presence changed", diff);
});
```

## Firebase Synchronization

### Comment Synchronization

```elixir

def handle_in("new_comment", %{"content" => content}, socket) do
  case Comments.create_comment(%{
      content: content,
      video_id: socket.assigns.video_id,
      user_id: socket.assigns.user_id
  }) do
      {:ok, comment} ->
        Task.start(fn ->
          RealtimeServer.Firebase.push_comment(comment)
        end)
        broadcast!(socket, "new_comment", %{
          id: comment.id,
          content: comment.content,
          user_id: comment.user_id
        })
        {:reply, :ok, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{reason: "Failed to create comment"}}, socket}
  end
end
```

## Error Handling

### Connection Management

```javascript
// Socket error handling
socket.onError((error) => {
  console.error("Socket error", error);
  // Implement reconnection logic
});
// Channel error handling
channel.onError((error) => {
  console.error("Channel error", error);
  // Handle channel-specific errors
});
```

### Rate Limiting

```elixir

defmodule RealtimeServer.RateLimit do
  def check_rate(user_id, action) do
      case Hammer.check_rate("#{action}:#{user_id}", 60_000, 30) do
        {:allow, _count} -> :ok
        {:deny, _limit} -> {:error, :rate_limit_exceeded}
      end
  end
end
```

## Best Practices

1. **Connection Management**

- Implement exponential backoff for reconnections
- Handle connection timeouts gracefully
- Monitor connection health

2. **Performance**

- Use presence diffing for large channels
- Implement pagination for historical data
- Optimize broadcast patterns

3. **Security**

- Validate all incoming messages
- Implement proper authentication
- Use rate limiting for all actions
