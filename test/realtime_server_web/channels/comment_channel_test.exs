defmodule RealtimeServerWeb.CommentChannelTest do
  use RealtimeServerWeb.ChannelCase
  alias RealtimeServer.Guardian

  setup do
    user = insert(:user)
    {:ok, token, _claims} = Guardian.encode_and_sign(user)
    video_id = "test_video_123"

    {:ok, socket} = connect(RealtimeServerWeb.UserSocket, %{"token" => token})
    {:ok, _, socket} = subscribe_and_join(socket, "comments:#{video_id}", %{})

    %{socket: socket, user: user, video_id: video_id}
  end

  describe "new_comment" do
    test "broadcasts comment after creation", %{socket: socket} do
      content = "Test comment"
      push(socket, "new_comment", %{"content" => content})

      assert_broadcast "new_comment", %{
        content: ^content,
        user_id: _user_id,
        id: _id,
        inserted_at: _inserted_at
      }
    end

    test "fails with invalid data", %{socket: socket} do
      ref = push(socket, "new_comment", %{"content" => ""})
      assert_reply ref, :error, %{reason: "Failed to create comment"}
    end
  end

  test "presence tracking after join", %{socket: socket, user: user} do
    assert_push "presence_state", %{}
    
    # Verify that the user is tracked in presence
    assert %{^user => %{metas: [%{online_at: _}]}} = 
      RealtimeServer.Presence.list(socket)
  end
end 