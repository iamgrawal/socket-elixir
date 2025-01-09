# Deployment Guide

## Production Checklist

### Environment Configuration

1. Set up production secrets:

```elixir
# config/prod.secret.exs

use Mix.Config
config :realtime_server, RealtimeServerWeb.Endpoint,
secret_key_base: System.get_env("SECRET_KEY_BASE"),
server: true
config :realtime_server, RealtimeServer.Repo,
username: System.get_env("DATABASE_USERNAME"),
password: System.get_env("DATABASE_PASSWORD"),
database: System.get_env("DATABASE_NAME"),
hostname: System.get_env("DATABASE_HOST"),
pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")
```

2. Configure SSL:

```elixir
# config/prod.exs

config :realtime_server, RealtimeServerWeb.Endpoint,
url: [host: System.get_env("PHX_HOST"), port: 443],
cache_static_manifest: "priv/static/cache_manifest.json",
force_ssl: [rewrite_on: [:x_forwarded_proto]],
https: [
port: 443,
cipher_suite: :strong,
certfile: System.get_env("SSL_CERT_PATH"),
keyfile: System.get_env("SSL_KEY_PATH")
]
```

### Release Configuration

Create a release configuration:

```elixir
# rel/config.exs

environment :prod do
set include_erts: true
set include_src: false
set cookie: :"your-secret-cookie"
end
release :realtime_server do
set version: current_version(:realtime_server)
set applications: [
:runtime_tools
]
end
```

## Docker Deployment

### Dockerfile

```dockerfile

# Build stage

FROM elixir:1.14.3-alpine AS builder

# Install build dependencies

RUN apk add --no-cache build-base npm git python3

# Prepare build directory

WORKDIR /app

# Install hex + rebar

RUN mix local.hex --force && \
 mix local.rebar --force

# Set mix env

ENV MIX_ENV=prod

# Install mix dependencies

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

# Copy compile-time config files

COPY config config

# Copy required application files

COPY lib lib
COPY priv priv

# Compile the release

RUN mix do compile, release

# Start a new build stage

FROM alpine:3.14 AS app
RUN apk add --no-cache openssl ncurses-libs
WORKDIR /app

# Copy the release from the builder

COPY --from=builder /app/\_build/prod/rel/realtime_server ./

# Set the environment

ENV HOME=/app
CMD ["bin/realtime_server", "start"]
```

### Docker Compose

```yaml
version: "3.8"
services:
app:
  - build: .
  - ports: "4000:4000"
  - environment:
      - DATABASE_URL=ecto://user:pass@db/realtime_server
      - SECRET_KEY_BASE=your-secret-key
      - PHX_HOST=your-domain.com
      - depends_on:
          - db
      - db:
          - image: mysql:8.0
          - environment:
              - MYSQL_ROOT_PASSWORD=your-root-password
              - MYSQL_DATABASE=realtime_server
              - MYSQL_USER=user
              - MYSQL_PASSWORD=pass
      - volumes:
          - db_data:/var/lib/mysql
  - volumes:
      - db_data:
```

## Monitoring

### Logging

Configure logging in production:

```elixir
# config/prod.exs
config :logger,
level: :info,
backends: [:console, {LogstashJson.Console, :json}]
config :logger, :console,
format: "$time $metadata[$level] $message\n",
metadata: [:request_id, :user_id]
```

### Health Checks

```elixir
# lib/realtime_server_web/controllers/health_controller.ex
defmodule RealtimeServerWeb.HealthController do
  use RealtimeServerWeb, :controller
  def index(conn, \_params) do
      # Check database connection
      Ecto.Adapters.SQL.query!(RealtimeServer.Repo, "SELECT 1")
      conn
      |> put_status(:ok)
      |> json(%{status: "healthy"})
  rescue
      _ ->
        conn
        |> put_status(:service_unavailable)
        |> json(%{status: "unhealthy"})
  end
end
```

### Metrics

Set up Prometheus metrics:

```elixir

# lib/realtime_server/metrics.ex
defmodule RealtimeServer.Metrics do
  use Prometheus.Metric
  def setup do
      Prometheus.Registry.register_collector(:prometheus_process_collector)
      Counter.declare(
        name: :realtime_server_comments_total,
        help: "Total number of comments"
      )
      Gauge.declare(
        name: :realtime_server_users_online,
        help: "Number of users currently online"
      )
  end
end
```

## Scaling

### Load Balancing

Example nginx configuration:

```nginx
upstream phoenix_upstream {
  server 127.0.0.1:4000;
  server 127.0.0.1:4001;
  server 127.0.0.1:4002;
}
server {
  listen 80;
  server_name your-domain.com;
  location / {
    proxy_pass http://phoenix_upstream;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
  }
}
```

### Database Scaling

Configure read replicas:

```elixir
# config/prod.exs
config :realtime_server, RealtimeServer.Repo,
username: System.get_env("DATABASE_USERNAME"),
password: System.get_env("DATABASE_PASSWORD"),
database: System.get_env("DATABASE_NAME"),
hostname: System.get_env("DATABASE_HOST"),
pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
ssl: true,
replicas: [
    [
      hostname: System.get_env("DATABASE_REPLICA_1_HOST")
    ],
    [
      hostname: System.get_env("DATABASE_REPLICA_2_HOST")
    ]
]
```
