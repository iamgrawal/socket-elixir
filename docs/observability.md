# Observability Guide

## Overview

The Realtime Server implements a comprehensive observability stack with logging, metrics, and telemetry. The system is designed with a pluggable architecture that allows easy integration of different monitoring solutions.

## Components

### 1. Logging System

The logging system supports multiple backends through a facade pattern:

```elixir
alias RealtimeServer.Observability.Logger

# Basic logging
Logger.info("User logged in", %{user_id: user.id})
Logger.error("Failed to process payment", %{error: error_message})

# Automatic metadata enrichment
# - timestamp
# - environment
# - service name
# - process ID
```

#### Available Backends

- Console Logger (default)
- Datadog Logger
- Add your custom logger by implementing the `RealtimeServer.Observability.Logger` behaviour

### 2. Metrics Collection

The metrics system supports various types of measurements:

```elixir
alias RealtimeServer.Observability.Metrics

# Counter
Metrics.increment("comments.created", 1, user_id: user.id)

# Gauge
Metrics.gauge("users.online", count, region: "us-east")

# Histogram
Metrics.histogram("request.duration", duration_ms, route: "/api/comments")
```

#### Available Backends

- Prometheus (default)
- Add your custom metrics backend by implementing the `RealtimeServer.Observability.Metrics` behaviour

### 3. Telemetry

Automatic monitoring for:

- HTTP requests
- WebSocket connections
- Database queries
- VM metrics

## Configuration

### Environment Variables

```bash
# Logging
LOG_LEVEL=info                        # Log level (debug, info, warning, error)

# Datadog (optional)
ENABLE_DATADOG=false                  # Enable Datadog integration
DATADOG_API_KEY=your-api-key          # Datadog API key
DATADOG_APP_KEY=your-app-key          # Datadog application key

# Prometheus
PROMETHEUS_PORT=9568                  # Prometheus metrics endpoint port
```

### Application Configuration

```elixir
# config/config.exs
config :realtime_server,
  logger_backends: [
    RealtimeServer.Observability.Loggers.Console,
    RealtimeServer.Observability.Loggers.Datadog
  ],
  metrics_backends: [
    RealtimeServer.Observability.Metrics.Prometheus
  ]

# Telemetry configuration
config :telemetry_metrics,
  reporter_options: [
    host: "localhost",
    port: 9568,
    protocol: :http
  ]
```

## Metrics Reference

### HTTP Metrics

- `phoenix.request.duration` (histogram)

  - Tags: route, status
  - Description: Request duration in milliseconds

- `phoenix.request.count` (counter)
  - Tags: route, status
  - Description: Number of requests

### Database Metrics

- `database.query.duration` (histogram)

  - Tags: source, operation
  - Description: Query execution time in milliseconds

- `database.query.count` (counter)
  - Tags: source, operation
  - Description: Number of queries

### WebSocket Metrics

- `websocket.connections` (gauge)

  - Tags: channel
  - Description: Current number of WebSocket connections

- `websocket.messages` (counter)
  - Tags: channel, event
  - Description: Number of WebSocket messages

## Best Practices

### 1. Logging

- Use structured logging with meaningful metadata
- Log at appropriate levels
- Include relevant context (user_id, request_id, etc.)

```elixir
# Good
Logger.info("Comment created", %{
  user_id: user.id,
  comment_id: comment.id,
  video_id: video.id
})

# Bad
Logger.info("User #{user.id} created comment #{comment.id}")
```

### 2. Metrics

- Use consistent naming conventions
- Add relevant tags for filtering
- Monitor both technical and business metrics

```elixir
# Good
Metrics.histogram("comment.creation.duration", duration, [
  user_id: user.id,
  video_id: video.id,
  region: "us-east"
])

# Bad
Metrics.histogram("duration", duration)
```

### 3. Alerts

Set up alerts for:

- High error rates
- Slow database queries (> 100ms)
- High memory usage
- Connection pool saturation
- High latency (> 500ms)

## Adding New Monitoring Solutions

### 1. Adding a New Logger

```elixir
defmodule RealtimeServer.Observability.Loggers.NewLogger do
  @behaviour RealtimeServer.Observability.Logger

  def log(level, message, metadata) do
    # Implement logging logic
  end

  def flush do
    # Implement flush logic
  end
end
```

### 2. Adding a New Metrics Backend

```elixir
defmodule RealtimeServer.Observability.Metrics.NewMetrics do
  @behaviour RealtimeServer.Observability.Metrics

  def increment(name, value, tags) do
    # Implement increment logic
  end

  def gauge(name, value, tags) do
    # Implement gauge logic
  end

  def histogram(name, value, tags) do
    # Implement histogram logic
  end
end
```

## Dashboard Setup

### Prometheus + Grafana

1. Basic metrics dashboard
2. Request latency dashboard
3. Database performance dashboard
4. WebSocket connections dashboard

### Datadog

1. APM dashboard
2. Log analytics dashboard
3. Infrastructure dashboard
