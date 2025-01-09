defmodule RealtimeServer.Observability.Loggers.Datadog do
  @behaviour RealtimeServer.Observability.Logger

  def log(level, message, metadata) do
    # Implement Datadog logging
    # This is a placeholder for the actual implementation
    {:ok, _} = Datadog.Logger.log(level, message, metadata)
    :ok
  end

  def flush, do: :ok
end
