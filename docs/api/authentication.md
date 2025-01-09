# Authentication API

## Overview

Authentication in the Realtime Server uses JWT tokens with device-based session management.

## Endpoints

### Register

```http
POST /api/register
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "password123",
    "username": "testuser"
  }
}
```

### Login

```http
POST /api/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "device_id": "device123"
}
```

### Refresh Token

```http
POST /api/refresh-token
Authorization: Bearer <token>
```

### Logout

```http
POST /api/logout
Authorization: Bearer <token>
Content-Type: application/json

{
  "device_id": "device123"
}
```
