defmodule RealtimeServer.Observability.Metrics.Prometheus do
  @behaviour RealtimeServer.Observability.Metrics

  def increment(name, value, tags) do
    :prometheus_counter.inc(
      [name: name_to_atom(name), labels: tag_names(tags)],
      tag_values(tags),
      value
    )
  end

  def gauge(name, value, tags) do
    :prometheus_gauge.set(
      [name: name_to_atom(name), labels: tag_names(tags)],
      tag_values(tags),
      value
    )
  end

  def histogram(name, value, tags) do
    :prometheus_histogram.observe(
      [name: name_to_atom(name), labels: tag_names(tags)],
      tag_values(tags),
      value
    )
  end

  defp name_to_atom(name) when is_binary(name), do: String.to_atom(name)
  defp name_to_atom(name) when is_atom(name), do: name

  defp tag_names(tags), do: Keyword.keys(tags)
  defp tag_values(tags), do: Keyword.values(tags)
end
