defmodule RealtimeServerWeb.AuthView do
  use RealtimeServerWeb, :view

  def render("register.json", %{user: user, token: token}) do
    %{
      message: "User created successfully",
      data: %{
        user: user_json(user),
        token: token
      }
    }
  end

  def render("login.json", %{user: user, token: token}) do
    %{
      message: "Login successful",
      data: %{
        user: user_json(user),
        token: token
      }
    }
  end

  def render("logout.json", %{message: message}) do
    %{
      message: message
    }
  end

  def render("token.json", %{token: token}) do
    %{
      message: "Token refreshed successfully",
      data: %{
        token: token
      }
    }
  end

  defp user_json(user) do
    %{
      id: user.id,
      email: user.email,
      username: user.username
    }
  end
end 