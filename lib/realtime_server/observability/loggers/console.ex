defmodule RealtimeServer.Observability.Loggers.Console do
  @behaviour RealtimeServer.Observability.Logger

  require Logger

  def log(level, message, metadata) do
    Logger.log(level, fn -> format_log(message, metadata) end)
  end

  def flush, do: :ok

  defp format_log(message, metadata) do
    metadata_string =
      metadata
      |> Enum.map(fn {k, v} -> "#{k}=#{inspect(v)}" end)
      |> Enum.join(" ")

    "#{message} #{metadata_string}"
  end
end
