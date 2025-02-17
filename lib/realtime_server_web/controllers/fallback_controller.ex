defmodule RealtimeServerWeb.FallbackController do
  use RealtimeServerWeb, :controller

  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(RealtimeServerWeb.ErrorView)
    |> render("422.json", changeset: changeset)
  end

  def call(conn, {:error, :invalid_credentials}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(RealtimeServerWeb.ErrorView)
    |> render("401.json", message: "Invalid email or password")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:unauthorized)
    |> put_view(RealtimeServerWeb.ErrorView)
    |> render("401.json", message: "Unauthorized")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(RealtimeServerWeb.ErrorView)
    |> render("404.json", message: "Resource not found")
  end
end 