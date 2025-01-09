defmodule RealtimeServer.FirebaseTest do
  use ExUnit.Case, async: true
  import Mock
  alias RealtimeServer.Firebase

  describe "push_comment/1" do
    test "successfully pushes comment to Firebase" do
      comment = %{
        video_id: "123",
        content: "Test comment",
        user_id: "user_1",
        inserted_at: DateTime.utc_now()
      }

      with_mock HTTPoison, [
        post: fn _url, _payload, _headers -> 
          {:ok, %HTTPoison.Response{status_code: 200, body: "ok"}}
        end
      ] do
        assert :ok = Firebase.push_comment(comment)
        
        assert_called HTTPoison.post(
          :_, 
          :_, 
          [{"Authorization", :_}, {"Content-Type", "application/json"}]
        )
      end
    end
  end
end 