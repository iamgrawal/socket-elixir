#!/bin/sh

# Wait for database if needed
while ! nc -z db 3306; do
  echo "Waiting for MySQL..."
  sleep 1
done

# Run migrations
/app/bin/realtime_server eval "RealtimeServer.Release.migrate"

# Start the application
exec /app/bin/realtime_server start 