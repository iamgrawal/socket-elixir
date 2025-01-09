defmodule RealtimeServerWeb.Auth.Pipeline do
  @moduledoc """
  Pipeline for Guardian authentication in Phoenix endpoints.
  """

  use Guardian.Plug.Pipeline,
    otp_app: :realtime_server,
    error_handler: RealtimeServerWeb.Auth.ErrorHandler,
    module: RealtimeServer.Guardian

  plug Guardian.Plug.VerifyHeader, claims: %{"typ" => "access"}
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end 