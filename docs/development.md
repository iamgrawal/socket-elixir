- # Development Guide
-
- ## Code Organization
-
- ```

  ```
- lib/
- ├── realtime_server/ # Business logic
- │ ├── accounts/ # User management
- │ ├── comments/ # Comment context
- │ ├── firebase/ # Firebase integration
- │ ├── presence/ # Presence tracking
- │ └── observability/ # Monitoring
- ├── realtime_server_web/ # Web layer
- │ ├── channels/ # WebSocket channels
- │ ├── controllers/ # REST controllers
- │ └── views/ # JSON views
- └── mix.exs # Project configuration
- ```

  ```
-
- ## Development Workflow
-
- ### 1. Setup Development Environment
-
- ```bash

  ```
- # Clone repository
- git clone https://github.com/your-org/realtime-server.git
- cd realtime-server
-
- # Install dependencies
- mix deps.get
-
- # Setup database
- mix ecto.setup
- ```

  ```
-
- ### 2. Running Tests
-
- ```bash

  ```
- # Run all tests
- mix test
-
- # Run with coverage
- mix coveralls
-
- # Run specific test file
- mix test test/realtime_server/comments_test.exs
- ```

  ```
-
- ### 3. Code Quality
-
- ```bash

  ```
- # Format code
- mix format
-
- # Run linter
- mix credo --strict
-
- # Run type checking
- mix dialyzer
- ```

  ```
-
- ## Testing Strategy
-
- ### Unit Tests
- - Controllers
- - Contexts
- - Channels
- - Views
-
- ### Integration Tests
- - API endpoints
- - WebSocket connections
- - Database operations
-
- ### Performance Tests
- - Load testing
- - Stress testing
- - Connection limits
-
- ## Git Workflow
-
- ### Branch Naming
- - `feature/` - New features
- - `fix/` - Bug fixes
- - `docs/` - Documentation
- - `refactor/` - Code refactoring
-
- ### Commit Messages
- ```

  ```
- feat: add user presence tracking
- fix: handle disconnection edge case
- docs: update API documentation
- refactor: improve error handling
- ```

  ```
-
- ## Debugging
-
- ### Logging
- ```elixir

  ```
- Logger.debug("Debug message", user_id: user.id)
- Logger.info("Info message", %{event: "user_login"})
- Logger.warning("Warning message", %{error: error})
- ```

  ```
-
- ### IEx Session
- ```bash

  ```
- iex -S mix phx.server
- ```

  ```
-
- ### Observer
- ```bash

  ```
- :observer.start()
- ```

  ```
