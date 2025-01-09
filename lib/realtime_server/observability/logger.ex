defmodule RealtimeServer.Observability.Logger do
  @moduledoc """
  Logger interface that supports multiple logging backends.
  Implements a facade pattern for easy backend swapping and multiple logger support.
  """

  require Logger

  @type log_level :: :emergency | :alert | :critical | :error | :warning | :notice | :info | :debug
  @type metadata :: keyword() | map()

  @callback log(log_level(), String.t(), metadata()) :: :ok
  @callback flush() :: :ok

  def log(level, message, metadata \\ %{}) do
    backends()
    |> Enum.each(& &1.log(level, message, enrich_metadata(metadata)))
  end

  def error(message, metadata \\ %{}), do: log(:error, message, metadata)
  def warning(message, metadata \\ %{}), do: log(:warning, message, metadata)
  def info(message, metadata \\ %{}), do: log(:info, message, metadata)
  def debug(message, metadata \\ %{}), do: log(:debug, message, metadata)

  defp backends do
    Application.get_env(:realtime_server, :logger_backends, [
      RealtimeServer.Observability.Loggers.Console
    ])
  end

  defp enrich_metadata(metadata) do
    Map.merge(
      %{
        timestamp: DateTime.utc_now(),
        environment: Application.get_env(:realtime_server, :environment),
        service: "realtime_server",
        pid: inspect(self())
      },
      metadata
    )
  end
end
