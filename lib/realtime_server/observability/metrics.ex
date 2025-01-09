defmodule RealtimeServer.Observability.Metrics do
  @moduledoc """
  Metrics interface supporting multiple metric backends.
  """

  @type metric_type :: :counter | :gauge | :histogram | :summary
  @type metric_name :: String.t()
  @type metric_value :: number()
  @type tags :: keyword() | map()

  @callback increment(metric_name(), metric_value(), tags()) :: :ok
  @callback gauge(metric_name(), metric_value(), tags()) :: :ok
  @callback histogram(metric_name(), metric_value(), tags()) :: :ok
  @callback summary(metric_name(), metric_value(), tags()) :: :ok

  def increment(name, value \\ 1, tags \\ []) do
    backends()
    |> Enum.each(& &1.increment(name, value, enrich_tags(tags)))
  end

  def gauge(name, value, tags \\ []) do
    backends()
    |> Enum.each(& &1.gauge(name, value, enrich_tags(tags)))
  end

  def histogram(name, value, tags \\ []) do
    backends()
    |> Enum.each(& &1.histogram(name, value, enrich_tags(tags)))
  end

  defp backends do
    Application.get_env(:realtime_server, :metrics_backends, [
      RealtimeServer.Observability.Metrics.Prometheus
    ])
  end

  defp enrich_tags(tags) do
    Keyword.merge(
      [
        environment: Application.get_env(:realtime_server, :environment),
        service: "realtime_server"
      ],
      tags
    )
  end
end
