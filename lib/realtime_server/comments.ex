defmodule RealtimeServer.Comments do
  @moduledoc """
  The Comments context.
  """

  import Ecto.Query, warn: false
  alias RealtimeServer.Repo
  alias RealtimeServer.Comments.Comment

  @doc """
  Returns the list of comments for a video.

  ## Examples

      iex> list_comments("video123")
      [%Comment{}, ...]

  """
  def list_comments(video_id, opts \\ []) do
    limit = Keyword.get(opts, :limit, 50)
    offset = Keyword.get(opts, :offset, 0)

    Comment
    |> where(video_id: ^video_id)
    |> order_by([desc: :inserted_at])
    |> limit(^limit)
    |> offset(^offset)
    |> Repo.all()
    |> Repo.preload(:user)
  end

  @doc """
  Gets a single comment.

  Raises `Ecto.NoResultsError` if the Comment does not exist.

  ## Examples

      iex> get_comment!("123")
      %Comment{}

      iex> get_comment!("456")
      ** (Ecto.NoResultsError)

  """
  def get_comment!(id), do: Repo.get!(Comment, id)

  @doc """
  Gets a single comment.
  Returns {:ok, comment} if found, {:error, :not_found} otherwise.
  """
  def get_comment(id) do
    case Repo.get(Comment, id) do
      nil -> {:error, :not_found}
      comment -> {:ok, comment}
    end
  end

  @doc """
  Creates a comment.

  ## Examples

      iex> create_comment(%{field: value})
      {:ok, %Comment{}}

      iex> create_comment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_comment(attrs \\ %{}) do
    %Comment{}
    |> Comment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a comment.

  ## Examples

      iex> delete_comment(comment)
      {:ok, %Comment{}}

      iex> delete_comment(comment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end
end 