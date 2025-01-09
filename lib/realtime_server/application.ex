defmodule RealtimeServer.Application do
  use Application

  def start(_type, _args) do
    children = [
      RealtimeServerWeb.Endpoint,
      RealtimeServer.Repo,
      RealtimeServer.Presence,
      RealtimeServer.Firebase,
      {Phoenix.PubSub, name: RealtimeServer.PubSub}
    ]

    opts = [strategy: :one_for_one, name: RealtimeServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end 