defmodule RealtimeServerWeb.ErrorView do
  use RealtimeServerWeb, :view

  def render("404.json", %{message: message}) do
    %{
      error: %{
        code: "not_found",
        message: message
      }
    }
  end

  def render("401.json", %{message: message}) do
    %{
      error: %{
        code: "unauthorized",
        message: message
      }
    }
  end

  def render("422.json", %{changeset: changeset}) do
    %{
      error: %{
        code: "validation_error",
        message: "Invalid parameters",
        details: translate_errors(changeset)
      }
    }
  end

  def render("500.json", _assigns) do
    %{
      error: %{
        code: "internal_server_error",
        message: "Internal server error"
      }
    }
  end

  # Helpers to translate changeset errors
  defp translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end
end 