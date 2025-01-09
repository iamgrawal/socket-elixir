defmodule RealtimeServerWeb.UserView do
  use RealtimeServerWeb, :view

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      username: user.username,
      email: user.email
    }
  end
end 