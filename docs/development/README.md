# Development Guide

## Setup Development Environment

### Prerequisites

- Elixir 1.14.3 or later
- Erlang/OTP 25.0 or later
- MySQL 8.0
- Firebase project with Realtime Database
- Git

### Initial Setup

1. Clone and setup the project:

```bash
# Clone repository
git clone https://github.com/yourusername/realtime_server.git
cd realtime_server

# Install dependencies
mix deps.get
```

2. Configure environment variables:

```bash
# Copy example env file
cp .env.example .env

# Edit your .env file with your settings
export FIREBASE_URL="your-firebase-url"
export FIREBASE_PROJECT_ID="your-project-id"
export GUARDIAN_SECRET_KEY="your-secret-key"
export DATABASE_USERNAME="your-db-username"
export DATABASE_PASSWORD="your-db-password"
export DATABASE_HOST="localhost"
```

3. Setup the database:

```bash
mix ecto.create
mix ecto.migrate
```

4. Install development tools:

```bash
# Install pre-commit hooks
chmod +x scripts/pre-commit.sh
ln -s ../../scripts/pre-commit.sh .git/hooks/pre-commit
```

## Development Workflow

### Code Style

We follow Elixir's standard code style with some additional rules:

```elixir
# Good
def some_function(arg1, arg2) do
  case process_args(arg1, arg2) do
    {:ok, result} -> {:ok, result}
    {:error, reason} -> {:error, reason}
  end
end

# Bad
def some_function arg1,arg2 do
  case process_args arg1,arg2 do
    {:ok,result}->{:ok,result}
    {:error,reason}->{:error,reason}
  end
end
```

### Branch Strategy

- `main` - Production-ready code
- `develop` - Integration branch
- `feature/*` - New features
- `fix/*` - Bug fixes
- `release/*` - Release preparation

### Commit Messages

Follow conventional commits:

```bash
feat: add user presence tracking
fix: handle disconnected socket
docs: update API documentation
test: add channel tests
refactor: improve firebase sync
```

### Pull Request Process

1. Create feature branch
2. Write tests
3. Update documentation
4. Submit PR
5. Address review comments
6. Merge after approval

## Testing

### Running Tests

```bash
# Run all tests
mix test

# Run specific test file
mix test test/realtime_server/firebase_test.exs

# Run tests with coverage
mix coveralls.html

# Run continuous testing
mix test.watch
```

### Code Quality Checks

```bash
# Run all quality checks
mix test.all

# Format code
mix format

# Run Credo
mix credo --strict

# Run Dialyzer
mix dialyzer
```

## Debugging

### IEx.pry

```elixir
def some_function do
  require IEx; IEx.pry
  # code to debug
end
```

### Logger

```elixir
require Logger

Logger.debug("Debug message")
Logger.info("Info message")
Logger.warn("Warning message")
Logger.error("Error message")
```

## Performance Optimization

### Database

```elixir
# Use Ecto.Repo.explain
Repo.explain(:all, query)

# Use async tasks for background operations
Task.async(fn ->
  # Background work
end)
```

### WebSocket

- Monitor connection count
- Implement rate limiting
- Use presence for tracking

## IDE Setup

### VS Code

1. Install extensions:

   - ElixirLS
   - Phoenix Framework
   - GitLens

2. Configure settings.json:

```json
{
  "elixir.enableTestLenses": true,
  "elixir.credo.strictMode": true,
  "editor.formatOnSave": true,
  "editor.rulers": [120],
  "[elixir]": {
    "editor.defaultFormatter": "JakeBecker.elixir-ls"
  }
}
```
