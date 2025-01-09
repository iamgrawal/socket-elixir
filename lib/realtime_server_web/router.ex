defmodule RealtimeServerWeb.Router do
  use RealtimeServerWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug RealtimeServerWeb.Auth.Pipeline
  end

  scope "/api", RealtimeServerWeb do
    pipe_through :api

    post "/register", AuthController, :register
    post "/login", AuthController, :login
  end

  scope "/api", RealtimeServerWeb do
    pipe_through [:api, :auth]

    post "/logout", AuthController, :logout
    post "/refresh-token", AuthController, :refresh_token
    
    resources "/comments", CommentController, except: [:new, :edit]
  end

  # Socket handler
  socket "/socket", RealtimeServerWeb.UserSocket,
    websocket: true,
    longpoll: false
end 