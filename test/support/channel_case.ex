defmodule RealtimeServerWeb.ChannelCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Phoenix.ChannelTest
      import RealtimeServer.Factory
      
      @endpoint RealtimeServerWeb.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(RealtimeServer.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(RealtimeServer.Repo, {:shared, self()})
    end

    :ok
  end
end 