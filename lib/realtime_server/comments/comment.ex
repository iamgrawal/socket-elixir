defmodule RealtimeServer.Comments.Comment do
  @moduledoc """
  Schema and changeset for comments.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "comments" do
    field :content, :string
    field :video_id, :string
    
    belongs_to :user, RealtimeServer.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(comment, attrs) do
    comment
    |> cast(attrs, [:content, :video_id, :user_id])
    |> validate_required([:content, :video_id, :user_id])
    |> validate_length(:content, min: 1, max: 1000)
    |> foreign_key_constraint(:user_id)
  end
end 