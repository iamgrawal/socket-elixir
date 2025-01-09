defmodule RealtimeServer.MixProject do
  use Mix.Project

  def project do
    [
      app: :realtime_server,
      version: "0.1.0",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.json": :test
      ],
      # Documentation
      name: "Realtime Server",
      source_url: "https://github.com/yourusername/realtime_server",
      homepage_url: "https://github.com/yourusername/realtime_server",
      docs: [
        main: "readme",
        extras: ["README.md", "CHANGELOG.md"]
      ]
    ]
  end

  def application do
    [
      mod: {RealtimeServer.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:phoenix, "~> 1.7.10"},
      {:phoenix_pubsub, "~> 2.1"},
      {:phoenix_ecto, "~> 4.4"},
      {:ecto_sql, "~> 3.10"},
      {:myxql, "~> 0.6.0"},  # MySQL driver
      {:goth, "~> 1.3"},     # Google Auth for Firebase Admin
      {:pigeon, "~> 2.0.0"}, # For handling push notifications
      {:jason, "~> 1.4"},
      {:plug_cowboy, "~> 2.6"},
      {:guardian, "~> 2.3"},  # Authentication
      {:cors_plug, "~> 3.0"},  # CORS support
      # Testing and Development tools
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.18", only: :test},
      {:ex_machina, "~> 2.7.0", only: :test},
      {:mock, "~> 0.3.0", only: :test},
      {:dialyxir, "~> 1.4", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.1", only: [:dev, :test], runtime: false},
      
      # Documentation
      {:ex_doc, "~> 0.29", only: :dev, runtime: false},
      {:inch_ex, "~> 2.0", only: [:dev, :test]}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "test.all": [
        "format --check-formatted",
        "credo --strict",
        "dialyzer",
        "test"
      ]
    ]
  end
end 