defmodule Golf.PageController do
  use Golf.Web, :controller

  alias Golf.Course
  def index(conn, _params) do
    courses = Repo.all(Course)
    conn
    |> render("index.html", courses: courses)
  end
end
