defmodule RealtimeServer.Repo.Migrations.CreateUserDevices do
  use Ecto.Migration

  def change do
    create table(:user_devices, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false
      add :device_id, :string, null: false
      add :last_seen_at, :utc_datetime
      add :device_info, :map
      add :is_active, :boolean, default: true, null: false

      timestamps()
    end

    create unique_index(:user_devices, [:user_id, :device_id])
    create index(:user_devices, [:last_seen_at])
  end
end 