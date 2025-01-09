defmodule RealtimeServer.Observability.Telemetry do
  @moduledoc """
  Handles telemetry events from Phoenix and Ecto
  """

  alias RealtimeServer.Observability.{Logger, Metrics}

  def setup do
    events = [
      # Phoenix events
      [:phoenix, :router_dispatch, :start],
      [:phoenix, :router_dispatch, :stop],
      [:phoenix, :router_dispatch, :exception],

      # Phoenix Socket events
      [:phoenix, :socket_connected],
      [:phoenix, :channel_joined],
      [:phoenix, :channel_handled_in],

      # Ecto events
      [:realtime_server, :repo, :query],

      # VM metrics
      [:vm, :memory],
      [:vm, :total_run_queue_lengths]
    ]

    :telemetry.attach_many(
      "realtime-server-telemetry",
      events,
      &handle_event/4,
      nil
    )
  end

  def handle_event([:phoenix, :router_dispatch, :start], _measurements, metadata, _config) do
    Logger.debug("Starting request", metadata)
  end

  def handle_event([:phoenix, :router_dispatch, :stop], measurements, metadata, _config) do
    duration = System.convert_time_unit(measurements.duration, :native, :millisecond)

    Metrics.histogram("phoenix.request.duration", duration, [
      route: "#{metadata.route}",
      status: metadata.conn.status
    ])

    Logger.info("Completed request", Map.put(metadata, :duration_ms, duration))
  end

  def handle_event([:realtime_server, :repo, :query], measurements, metadata, _config) do
    duration = System.convert_time_unit(measurements.total_time, :native, :millisecond)

    Metrics.histogram("database.query.duration", duration, [
      source: metadata.source,
      operation: metadata.operation
    ])

    if duration > 100 do
      Logger.warning("Slow query detected", %{
        query: metadata.query,
        duration_ms: duration,
        source: metadata.source
      })
    end
  end

  # Add more event handlers as needed
end
