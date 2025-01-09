defmodule RealtimeServer.Accounts.User do
  @moduledoc """
  Schema and changeset for users.
  """

  use Ecto.Schema
  import Ecto.Changeset
  import Bcrypt, only: [hash_pwd_salt: 1]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "users" do
    field :email, :string
    field :username, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :last_login_at, :utc_datetime
    field :is_active, :boolean, default: true

    has_many :comments, RealtimeServer.Comments.Comment
    has_many :devices, RealtimeServer.Accounts.UserDevice

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :username, :password, :last_login_at, :is_active])
    |> validate_required([:email, :username, :password])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> put_password_hash()
  end

  defp put_password_hash(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    put_change(changeset, :password_hash, hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end 