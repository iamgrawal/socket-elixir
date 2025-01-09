defmodule RealtimeServer.Factory do
  use ExMachina.Ecto, repo: RealtimeServer.Repo

  def user_factory do
    %RealtimeServer.Accounts.User{
      email: sequence(:email, &"user#{&1}@example.com"),
      username: sequence(:username, &"user#{&1}"),
      password_hash: Bcrypt.hash_pwd_salt("password123")
    }
  end

  def comment_factory do
    %RealtimeServer.Comments.Comment{
      content: sequence(:content, &"This is comment #{&1}"),
      video_id: sequence(:video_id, &"video#{&1}"),
      user: build(:user)
    }
  end
end 