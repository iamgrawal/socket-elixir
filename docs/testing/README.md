# Testing Guide

## Overview

Our testing strategy includes:

- Unit tests for individual modules
- Integration tests for channels and APIs
- Property-based testing
- Automated code quality checks
- Coverage reporting

## Test Structure

Our tests are organized as follows:

```
test/
├── realtime_server/           # Unit tests
│   ├── firebase_test.exs      # Firebase integration tests
│   └── presence_test.exs      # Presence tracking tests
├── realtime_server_web/       # Integration tests
│   └── channels/
│       └── comment_channel_test.exs
├── support/                   # Test helpers
│   ├── channel_case.ex        # Channel test helpers
│   └── factory.ex             # Test data factories
└── test_helper.exs            # Test configuration
```

## Running Tests

### Basic Commands

```bash
# Run all tests
mix test

# Run a specific test file
mix test test/realtime_server/firebase_test.exs

# Run tests with coverage
mix coveralls.html

# Run all quality checks
mix test.all
```

## Test Configuration

### Test Helper

```elixir
# test/test_helper.exs
ExUnit.start(capture_log: true, trace: true)
{:ok, _} = Application.ensure_all_started(:ex_machina)

# Configure test database
Ecto.Adapters.SQL.Sandbox.mode(RealtimeServer.Repo, :manual)

# Mock Firebase in test environment
Application.put_env(:realtime_server, :firebase_client, RealtimeServer.MockFirebase)
```

### Channel Case

```elixir
# test/support/channel_case.ex
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
```

### Factories

```elixir
# test/support/factory.ex
defmodule RealtimeServer.Factory do
  use ExMachina.Ecto, repo: RealtimeServer.Repo

  def user_factory do
    %RealtimeServer.Accounts.User{
      email: sequence(:email, &"user#{&1}@example.com"),
      username: sequence(:username, &"user#{&1}"),
      password_hash: Bcrypt.hash_pwd_salt("password123")
    }
  end

  def comment_factory do
    %RealtimeServer.Comments.Comment{
      content: sequence(:content, &"This is comment #{&1}"),
      video_id: sequence(:video_id, &"video#{&1}"),
      user: build(:user)
    }
  end
end
```

## Code Quality Tools

### Credo Configuration

```elixir
# config/.credo.exs
%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "test/"],
        excluded: [~r"/_build/", ~r"/deps/"]
      },
      strict: true,
      checks: [
        {Credo.Check.Consistency.TabsOrSpaces, []},
        {Credo.Check.Design.TagTODO, [exit_status: 0]},
        {Credo.Check.Readability.ModuleDoc, []}
      ]
    }
  ]
}
```

### Pre-commit Hooks

```bash
# scripts/pre-commit.sh
#!/bin/sh

# Run tests
mix test || exit 1

# Run credo
mix credo --strict || exit 1

# Run dialyzer
mix dialyzer || exit 1

# Check formatting
mix format --check-formatted || exit 1
```
