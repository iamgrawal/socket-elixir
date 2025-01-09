# Getting Started Guide

## Prerequisites

Before you begin, ensure you have the following installed:

- Elixir 1.14 or later
- Erlang/OTP 25 or later
- MySQL 8.0 or later
- Node.js 16.x or later (for Firebase client)
- Git

## Installation

1. Clone the repository:

```bash
git clone https://github.com/your-org/realtime-server.git
cd realtime-server
```

2. Install dependencies:

```bash
mix deps.get
```

3. Set up environment variables:

```bash
# Create a .env file from the template
cp .env.example .env

# Edit the .env file with your configurations:
# Database configuration
export DATABASE_URL=mysql://user:pass@localhost/realtime_server_dev

# Firebase configuration
export FIREBASE_PROJECT_ID=your-project-id
export FIREBASE_PRIVATE_KEY=your-private-key
export FIREBASE_CLIENT_EMAIL=your-client-email

# Guardian configuration
export GUARDIAN_SECRET_KEY=your-guardian-secret
```

4. Set up the database:

```bash
mix ecto.setup
```

## Running the Server

1. Start the Phoenix server:

```bash
mix phx.server
```

The server will be available at `http://localhost:4000`

## Development Environment

### Running Tests

```bash
# Run all tests
mix test

# Run tests with coverage
mix coveralls

# Run specific test file
mix test test/realtime_server/comments_test.exs
```

### Code Quality

```bash
# Run the linter
mix credo

# Run formatter
mix format
```

## API Documentation

### Authentication

1. Register a new user:

```bash
curl -X POST http://localhost:4000/api/register \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "user@example.com", "password": "password123", "username": "testuser"}}'
```

2. Login:

```bash
curl -X POST http://localhost:4000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email": "user@example.com", "password": "password123", "device_id": "device123"}'
```

### WebSocket Connection

```javascript
// Connect to WebSocket
let socket = new Socket("ws://localhost:4000/socket", {
  params: { token: "your-jwt-token" },
});

socket.connect();

// Join a comment channel
let channel = socket.channel(`comments:${videoId}`, {});
channel
  .join()
  .receive("ok", (resp) => console.log("Joined successfully", resp))
  .receive("error", (resp) => console.log("Unable to join", resp));
```

## Common Issues and Solutions

### Database Connection Issues

If you encounter database connection issues:

1. Ensure MySQL is running:

```bash
mysql.server status
```

2. Verify database credentials in `.env`

3. Try resetting the database:

```bash
mix ecto.reset
```

### Firebase Connection Issues

1. Verify Firebase credentials in `.env`
2. Ensure Firebase project has the correct security rules
3. Check Firebase Admin SDK permissions

## Development Workflow

1. Create a new branch for your feature:

```bash
git checkout -b feature/your-feature-name
```

2. Make your changes and ensure all tests pass:

```bash
mix test
mix credo --strict
mix format
```

3. Commit your changes:

```bash
git commit -m "feat: add your feature description"
```

## Monitoring and Debugging

### Logging

Logs are written to:

- Development: Console output
- Production: `/var/log/realtime_server/`

View logs in development:

```bash
tail -f log/dev.log
```

### Performance Monitoring

1. Check application metrics:

```bash
mix observer
```

2. Monitor Phoenix endpoints:
   Visit `http://localhost:4000/dashboard` in development

## Next Steps

- Read the [Architecture Guide](architecture.md)
- Review [Real-time Features](realtime_features.md)
- Check [Firebase Integration](firebase_integration.md)
- Explore [API Reference](api_reference.md)
- Review [Deployment Guide](deployment.md)
