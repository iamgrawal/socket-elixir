defmodule RealtimeServer.Guardian do
  @moduledoc """
  Implementation module for Guardian JWT authentication.
  """

  use Guardian, otp_app: :realtime_server

  alias RealtimeServer.Accounts

  @doc """
  Used by Guardian to serialize a JWT token.
  """
  def subject_for_token(%{id: id}, _claims) do
    sub = to_string(id)
    {:ok, sub}
  end

  def subject_for_token(_, _) do
    {:error, :no_id_provided}
  end

  @doc """
  Used by Guardian to deserialize a JWT token.
  """
  def resource_from_claims(%{"sub" => id}) do
    case Accounts.get_user!(id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  rescue
    Ecto.NoResultsError -> {:error, :not_found}
  end

  def resource_from_claims(_claims) do
    {:error, :no_id_provided}
  end
end 