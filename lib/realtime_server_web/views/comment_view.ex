defmodule RealtimeServerWeb.CommentView do
  use RealtimeServerWeb, :view
  alias RealtimeServerWeb.{CommentView, UserView}

  def render("index.json", %{comments: comments}) do
    %{
      data: render_many(comments, CommentView, "comment.json")
    }
  end

  def render("show.json", %{comment: comment}) do
    %{
      data: render_one(comment, CommentView, "comment.json")
    }
  end

  def render("comment.json", %{comment: comment}) do
    %{
      id: comment.id,
      content: comment.content,
      video_id: comment.video_id,
      inserted_at: comment.inserted_at,
      user: render_one(comment.user, UserView, "user.json")
    }
  end
end 