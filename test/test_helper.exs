ExUnit.start(capture_log: true, trace: true)
{:ok, _} = Application.ensure_all_started(:ex_machina)

# Configure the test database
Ecto.Adapters.SQL.Sandbox.mode(RealtimeServer.Repo, :manual)

# Mock Firebase in test environment
Application.put_env(:realtime_server, :firebase_client, RealtimeServer.MockFirebase)

# Set up test environment variables
System.put_env("FIREBASE_URL", "https://test-project.firebaseio.com")
System.put_env("FIREBASE_PROJECT_ID", "test-project")
System.put_env("GUARDIAN_SECRET_KEY", "test_secret_key") 