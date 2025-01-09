config :realtime_server,
  ecto_repos: [RealtimeServer.Repo],
  firebase_url: System.get_env("FIREBASE_URL"),
  firebase_project_id: System.get_env("FIREBASE_PROJECT_ID")

config :realtime_server, RealtimeServer.Guardian,
  issuer: "realtime_server",
  secret_key: System.get_env("GUARDIAN_SECRET_KEY"),
  ttl: {7, :days}

# Database configuration
config :realtime_server, RealtimeServer.Repo,
  database: "realtime_server",
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  hostname: System.get_env("DATABASE_HOST")

config :realtime_server,
  logger_backends: [
    RealtimeServer.Observability.Loggers.Console
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
