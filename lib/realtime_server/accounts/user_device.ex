defmodule RealtimeServer.Accounts.UserDevice do
  @moduledoc """
  Schema and changeset for user devices.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "user_devices" do
    field :device_id, :string
    field :last_seen_at, :utc_datetime
    field :device_info, :map
    field :is_active, :boolean, default: true

    belongs_to :user, RealtimeServer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(user_device, attrs) do
    user_device
    |> cast(attrs, [:device_id, :last_seen_at, :device_info, :is_active, :user_id])
    |> validate_required([:device_id, :user_id])
    |> unique_constraint([:user_id, :device_id])
    |> foreign_key_constraint(:user_id)
  end
end 