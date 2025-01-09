defmodule RealtimeServerWeb.AuthController do
  use RealtimeServerWeb, :controller

  alias RealtimeServer.{Accounts, Guardian}
  
  action_fallback RealtimeServerWeb.FallbackController

  @doc """
  Handles user registration
  """
  def register(conn, %{"user" => user_params}) do
    with {:ok, user} <- Accounts.create_user(user_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:created)
      |> render("register.json", %{user: user, token: token})
    end
  end

  @doc """
  Handles user login
  """
  def login(conn, %{"email" => email, "password" => password, "device_id" => device_id}) do
    with {:ok, user} <- Accounts.authenticate_user(email, password),
         {:ok, token, _claims} <- Guardian.encode_and_sign(user),
         {:ok, _device} <- Accounts.register_device(user, device_id),
         {:ok, _user} <- Accounts.update_last_login(user) do
      
      # Optionally deactivate other devices if you want to enforce single device
      # Accounts.deactivate_other_devices(user, device_id)

      conn
      |> put_status(:ok)
      |> render("login.json", %{user: user, token: token})
    end
  end

  @doc """
  Handles user logout
  """
  def logout(conn, %{"device_id" => device_id}) do
    user = Guardian.Plug.current_resource(conn)

    with {:ok, _device} <- Accounts.deactivate_device(user, device_id) do
      conn
      |> put_status(:ok)
      |> render("logout.json", %{message: "Successfully logged out"})
    end
  end

  @doc """
  Refreshes the JWT token
  """
  def refresh_token(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    
    with {:ok, token, _claims} <- Guardian.encode_and_sign(user) do
      conn
      |> put_status(:ok)
      |> render("token.json", %{token: token})
    end
  end
end 