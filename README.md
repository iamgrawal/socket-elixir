# Realtime Server

A production-ready Elixir server implementation providing real-time features through WebSocket connections, with Firebase synchronization and MySQL persistence.

## Features

🔐 **Secure Authentication**

- JWT-based authentication
- Device-based session management
- Rate limiting

🚀 **Real-time Communication**

- WebSocket-based real-time updates
- Presence tracking
- Comment system

🔄 **Firebase Integration**

- Real-time data synchronization
- Fallback mechanism
- Background synchronization

📦 **Production Ready**

- Docker support
- Comprehensive documentation
- Test coverage
- Monitoring setup

📊 **Comprehensive Monitoring**

- Multi-backend logging system
- Metrics collection
- Telemetry integration
- Pluggable monitoring solutions

## Quick Start

### Prerequisites

- Elixir 1.14+
- Erlang/OTP 25+
- MySQL 8.0+
- Node.js 16+ (for Firebase client)

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/your-org/realtime-server.git
   cd realtime-server
   ```

2. Install dependencies:

   ```bash
   mix deps.get
   ```

3. Setup environment:

   ```bash
   cp .env.example .env
   # Edit .env with your configurations
   ```

4. Setup database:

   ```bash
   mix ecto.setup
   ```

5. Start the server:
   ```bash
   mix phx.server
   ```

### Docker Setup

```bash
docker-compose up --build
```

## Documentation

Detailed documentation is available in the [docs](./docs) directory:

- [Getting Started Guide](docs/getting_started.md)
- [Architecture Overview](docs/architecture.md)
- [Real-time Features](docs/realtime.md)
- [Firebase Integration](docs/firebase_integration.md)
- [Observability Guide](docs/observability.md)
- [API Reference](docs/api/README.md)
- [Deployment Guide](docs/deployment.md)

## Development

### Running Tests

```bash
# Run all tests
mix test

# Run with coverage
mix coveralls

# Run specific test file
mix test test/realtime_server/comments_test.exs
```

### Code Quality

```bash
# Run formatter
mix format

# Run linter
mix credo
```

## API Examples

### Authentication

```bash
# Register a new user
curl -X POST http://localhost:4000/api/register \
  -H "Content-Type: application/json" \
  -d '{"user": {"email": "user@example.com", "password": "password123", "username": "testuser"}}'

# Login
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

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Phoenix Framework](https://www.phoenixframework.org/)
- [Firebase](https://firebase.google.com/)
- [Guardian](https://github.com/ueberauth/guardian)
