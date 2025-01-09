defmodule RealtimeServer.Repo.Migrations.CreateComments do
  use Ecto.Migration

  def change do
    create table(:comments, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :content, :text, null: false
      add :video_id, :string, null: false
      add :user_id, references(:users, type: :binary_id, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:comments, [:video_id])
    create index(:comments, [:user_id])
    create index(:comments, [:inserted_at])
  end
end 