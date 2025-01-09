# Comments API

## Overview

The Comments API provides endpoints for managing video comments with real-time updates.

## REST Endpoints

### Create Comment

```http
POST /api/comments
Authorization: Bearer <token>
Content-Type: application/json
{
  "comment": {
    "content": "Great video!",
    "video_id": "video123"
  }
}
```

### List Comments

```http
GET /api/comments?video_id=video123&page=1&per_page=50
Authorization: Bearer <token>
```

### Delete Comment

```http
DELETE /api/comments/:id
Authorization: Bearer <token>
```

## WebSocket Events

### New Comment Event

```javascript
channel.on("new_comment", (payload) => {
  console.log("New comment:", payload);
});
```

### Comment Deleted Event

```javascript
channel.on("comment_deleted", (payload) => {
  console.log("Comment deleted:", payload);
});
```
