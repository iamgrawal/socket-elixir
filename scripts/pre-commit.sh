#!/bin/sh

# Run tests
mix test || exit 1

# Run credo
mix credo --strict || exit 1

# Run dialyzer
mix dialyzer || exit 1

# Check formatting
mix format --check-formatted || exit 1 