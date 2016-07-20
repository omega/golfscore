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
    resources "/courses", CourseController do
      resources "/holes", HoleController
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", Golf do
  #   pipe_through :api
  # end
end
