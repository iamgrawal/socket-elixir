defmodule RealtimeServer.Accounts do
  @moduledoc """
  The Accounts context handles user management and authentication.
  """

  import Ecto.Query, warn: false
  alias RealtimeServer.Repo
  alias RealtimeServer.Accounts.{User, UserDevice}

  @doc """
  Gets a user by email.
  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Gets a user by id.
  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Creates a user.
  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user's last login time.
  """
  def update_last_login(%User{} = user) do
    user
    |> Ecto.Changeset.change(%{last_login_at: DateTime.utc_now()})
    |> Repo.update()
  end

  @doc """
  Authenticates a user by email and password.
  """
  def authenticate_user(email, password) do
    user = get_user_by_email(email)
    do_authenticate_user(user, password)
  end

  @doc """
  Registers or updates a user device.
  """
  def register_device(%User{} = user, device_id, device_info \\ %{}) do
    attrs = %{
      user_id: user.id,
      device_id: device_id,
      device_info: device_info,
      last_seen_at: DateTime.utc_now(),
      is_active: true
    }

    case Repo.get_by(UserDevice, user_id: user.id, device_id: device_id) do
      nil -> %UserDevice{}
      device -> device
    end
    |> UserDevice.changeset(attrs)
    |> Repo.insert_or_update()
  end

  @doc """
  Deactivates all other devices for a user except the current one.
  """
  def deactivate_other_devices(%User{} = user, current_device_id) do
    from(d in UserDevice,
      where: d.user_id == ^user.id and d.device_id != ^current_device_id
    )
    |> Repo.update_all(set: [is_active: false])
  end

  # Private functions

  defp do_authenticate_user(nil, _password), do: {:error, :invalid_credentials}

  defp do_authenticate_user(%User{} = user, password) do
    if Bcrypt.verify_pass(password, user.password_hash) do
      {:ok, user}
    else
      {:error, :invalid_credentials}
    end
  end
end 