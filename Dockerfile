# Build stage
FROM hexpm/elixir:1.14.5-erlang-25.3.2-alpine-3.18.2 AS build

# Install build dependencies
RUN apk add --no-cache build-base git python3

# Prepare build directory
WORKDIR /app

# Install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Set build ENV
ENV MIX_ENV=prod

# Install mix dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

# Copy compile-time config files
COPY config config

# Compile dependencies
RUN mix deps.compile

# Copy application code
COPY priv priv
COPY lib lib

# Compile application
RUN mix compile

# Build release
COPY rel rel
RUN mix release

# Start a new build stage
FROM alpine:3.18.2 AS app

# Install runtime dependencies
RUN apk add --no-cache openssl ncurses-libs libstdc++

WORKDIR /app

# Copy release from build stage
COPY --from=build /app/_build/prod/rel/realtime_server ./

# Copy entry point script
COPY entrypoint.sh .
RUN chmod +x entrypoint.sh

# Set runtime ENV
ENV HOME=/app

CMD ["./entrypoint.sh"] 