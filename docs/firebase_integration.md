# Firebase Integration Guide

## Overview

This document describes how our Elixir server integrates with Firebase for real-time data synchronization. We use Firebase as a secondary database for real-time features while maintaining our primary data in MySQL.

## Configuration

### Environment Variables

The following environment variables need to be set:

```
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY=your-private-key
FIREBASE_CLIENT_EMAIL=your-client-email
```

### Firebase Admin SDK Setup

We use the Firebase Admin SDK through the `pigeon` library for server-side operations. The configuration is initialized in `config/config.exs`:

```elixir
config :realtime_server, RealtimeServer.Firebase,
project_id: System.get_env("FIREBASE_PROJECT_ID"),
private_key: System.get_env("FIREBASE_PRIVATE_KEY"),
client_email: System.get_env("FIREBASE_CLIENT_EMAIL")
```

## Data Synchronization

### Comment Synchronization

Comments are synchronized in real-time between MySQL and Firebase:

1. When a new comment is created through the API:

- First saved to MySQL
- Then pushed to Firebase in the background

2. When a comment is deleted:

- Removed from MySQL
- Deletion is propagated to Firebase

### Firebase Data Structure

```json
{
  "comments": {
    "video_id": {
      "comment_id": {
        "id": "uuid",
        "content": "comment text",
        "user": {
          "id": "user_id",
          "username": "username"
        },
        "created_at": "timestamp"
      }
    }
  },
  "presence": {
    "video_id": {
      "user_id": {
        "online": true,
        "last_seen": "timestamp"
      }
    }
  }
}
```

## Security Rules

### Firebase Security Rules

```javascript

{
  "rules": {
    "comments": {
      "$videoId": {
          ".read": true,
          ".write": false  // Only server can write
        }
    },
    "presence": {
      "$videoId": {
        ".read": true,
        ".write": "auth != null" // Authenticated users can update their presence
      }
    }
  }
}
```

## Error Handling

- Failed Firebase operations are logged and retried using exponential backoff
- Synchronization errors don't block the main application flow
- Critical errors trigger alerts through the configured monitoring system

## Best Practices

1. **Data Consistency**

- Always treat MySQL as the source of truth
- Use Firebase for real-time features only
- Implement periodic reconciliation jobs

2. **Performance**

- Use background tasks for Firebase operations
- Implement batching for bulk operations
- Cache Firebase Admin SDK tokens

3. **Security**

- Never expose Firebase admin credentials
- Implement proper security rules
- Validate data before synchronization

## Monitoring

Monitor these metrics for Firebase integration:

- Synchronization latency
- Failed operations count
- Retry attempts
- Token refresh rate
- Real-time connection status
