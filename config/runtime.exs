config :realtime_server, RealtimeServer.Repo,
  # Primary database configuration
  username: System.get_env("PRIMARY_DB_USERNAME"),
  password: System.get_env("PRIMARY_DB_PASSWORD"),
  database: System.get_env("PRIMARY_DB_NAME"),
  hostname: System.get_env("PRIMARY_DB_HOST"),
  port: String.to_integer(System.get_env("PRIMARY_DB_PORT", "3306")),
  pool_size: String.to_integer(System.get_env("POOL_SIZE", "10")),
  ssl: true,
  ssl_opts: [
    verify: :verify_peer,
    cacertfile: System.get_env("DB_CA_CERT"),
    server_name_indication: to_charlist(System.get_env("PRIMARY_DB_HOST"))
  ],
  # Read replica configuration
  replicas: [
    [
      username: System.get_env("REPLICA_1_DB_USERNAME"),
      password: System.get_env("REPLICA_1_DB_PASSWORD"),
      database: System.get_env("REPLICA_1_DB_NAME"),
      hostname: System.get_env("REPLICA_1_DB_HOST"),
      port: String.to_integer(System.get_env("REPLICA_1_DB_PORT", "3306")),
      ssl: true,
      ssl_opts: [
        verify: :verify_peer,
        cacertfile: System.get_env("DB_CA_CERT"),
        server_name_indication: to_charlist(System.get_env("REPLICA_1_DB_HOST"))
      ]
    ],
    [
      username: System.get_env("REPLICA_2_DB_USERNAME"),
      password: System.get_env("REPLICA_2_DB_PASSWORD"),
      database: System.get_env("REPLICA_2_DB_NAME"),
      hostname: System.get_env("REPLICA_2_DB_HOST"),
      port: String.to_integer(System.get_env("REPLICA_2_DB_PORT", "3306")),
      ssl: true,
      ssl_opts: [
        verify: :verify_peer,
        cacertfile: System.get_env("DB_CA_CERT"),
        server_name_indication: to_charlist(System.get_env("REPLICA_2_DB_HOST"))
      ]
    ]
  ]
