defmodule Golf.Router do
  use Golf.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Golf do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/sessions", SessionController, only: [:new, :create]
    get "/sessions/logout", SessionController, :logout
    resources "/users", UserController
    resources "/courses", CourseController do
      resources "/holes", HoleController
    end
    resources "/rounds", RoundController do
      get "player", RoundController, :new_player
      post "player", RoundController, :create_player

      get "score/:hole_id", RoundController, :record_score
      post "score/:hole_id", RoundController, :save_score
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Golf do
  #   pipe_through :api
  # end
end
