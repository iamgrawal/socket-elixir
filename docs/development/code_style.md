# Code Style Guide

## Elixir Style Guide

### Formatting

- Use `mix format` for consistent code formatting
- Maximum line length: 98 characters
- Use spaces around operators

### Naming Conventions

- Module names: `PascalCase`
- Function names: `snake_case`
- Variable names: `snake_case`
- Constants: `UPPERCASE_WITH_UNDERSCORES`

### Documentation

- Use `@moduledoc` for module documentation
- Use `@doc` for function documentation
- Include examples in documentation

### Testing

- Test file naming: `*_test.exs`
- Use descriptive test names
- Follow "Arrange-Act-Assert" pattern

## Project Structure

### Directory Organization

```
lib/
├── realtime_server/ # Business logic
│ ├── accounts/ # User management
│ ├── comments/ # Comment context
│ └── firebase/ # Firebase integration
└── realtime_server_web/ # Web layer
    ├── channels/         # WebSocket channels
    ├── controllers/      # REST controllers
    └── views/           # JSON views
```

### File Organization

- One module per file
- Group related modules in directories
- Keep files focused and small
