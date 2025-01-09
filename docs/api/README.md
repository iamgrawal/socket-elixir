# API Reference

## WebSocket API

### Socket Connection

```javascript
import { Socket } from "phoenix";

const socket = new Socket("/socket", {
  params: { token: "your-jwt-token" },
});

socket.connect();
```

### Channels

#### Comment Channel

Topic: `comments:{video_id}`

**Events:**

1. Join Channel

```javascript
const channel = socket.channel(`comments:${videoId}`, {});
channel
  .join()
  .receive("ok", (response) => {
    console.log("Joined", response);
  })
  .receive("error", (response) => {
    console.log("Failed to join", response);
  });
```

2. New Comment

```javascript
// Send
channel.push("new_comment", {
  content: "Great video!",
});

// Receive
channel.on("new_comment", (payload) => {
  console.log("New comment", payload);
});
```

3. Delete Comment

```javascript
channel.push("delete_comment", {
  comment_id: "123",
});
```

#### Presence Channel

Topic: `presence:{user_id}`

**Events:**

1. Track Presence

```javascript
channel.on("presence_state", (state) => {
  console.log("Current presence", state);
});

channel.on("presence_diff", (diff) => {
  console.log("Presence changed", diff);
});
```

## HTTP API

### Authentication

#### Login

```http
POST /api/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}
```

Response:

```json
{
  "token": "your-jwt-token",
  "user": {
    "id": "123",
    "email": "user@example.com",
    "username": "user123"
  }
}
```

#### Refresh Token

```http
POST /api/refresh_token
Authorization: Bearer your-jwt-token
```

### Comments

#### Get Video Comments

```http
GET /api/videos/:video_id/comments
Authorization: Bearer your-jwt-token
```

Response:

```json
{
  "comments": [
    {
      "id": "1",
      "content": "Great video!",
      "user_id": "123",
      "inserted_at": "2024-03-20T10:30:00Z"
    }
  ],
  "pagination": {
    "page": 1,
    "total_pages": 5,
    "total_count": 100
  }
}
```

## Error Handling

### HTTP Errors

```json
{
  "error": {
    "code": "unauthorized",
    "message": "Invalid credentials"
  }
}
```

### WebSocket Errors

```javascript
channel.onError((error) => {
  console.error("Channel error:", error);
});

socket.onError((error) => {
  console.error("Socket error:", error);
});
```

## Rate Limiting

- WebSocket: 30 messages per minute per user
- HTTP API: 100 requests per minute per IP

Rate limit headers:

```http
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1623456789
```

## Authentication

All API requests must include a JWT token in the Authorization header:

```http
Authorization: Bearer your-jwt-token
```

Token format:

```elixir
%{
  "sub": "user_id",
  "email": "user@example.com",
  "exp": 1623456789
}
```
