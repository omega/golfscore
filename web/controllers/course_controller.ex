defmodule Golf.CourseController do
  use Golf.Web, :controller

  alias Golf.Course
  alias Golf.Hole

  require Logger
  
  plug :scrub_params, "course" when action in [:create, :update]

  def index(conn, _params) do
    courses = Repo.all(Course)
    render(conn, "index.html", courses: courses)
  end

  def new(conn, _params) do
    changeset = Course.changeset(%Course{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"course" => course_params}) do
    {holes, course_params} = Map.pop(course_params, "make_holes")
    changeset = Course.changeset(%Course{}, course_params)

    case Repo.insert(changeset) do
      {:ok, course} ->
        # Create N holes with default par 3
        if holes do
          {holes, _} = Integer.parse(holes)
          Logger.info "Creating #{holes} holes"
          for h <- 1..holes do
            cs = course
              |> build_assoc(:holes)
              |> Hole.changeset(%{num: h, par: 3})
            case Repo.insert(cs) do
              {:ok, _hole} ->
                nil
              {:error, _cs} ->
                render(conn, "new.html", changeset: changeset)
            end
          end
        end
        conn
        |> put_flash(:info, "Course created successfully.")
        |> redirect(to: course_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    course = Course
      |> Repo.get!(id)
      |> Repo.preload(holes: from(h in Hole, order_by: h.num))
    render(conn, "show.html", course: course)
  end

  def edit(conn, %{"id" => id}) do
    course = Repo.get!(Course, id)
    changeset = Course.changeset(course)
    render(conn, "edit.html", course: course, changeset: changeset)
  end

  def update(conn, %{"id" => id, "course" => course_params}) do
    course = Repo.get!(Course, id)
    changeset = Course.changeset(course, course_params)

    case Repo.update(changeset) do
      {:ok, course} ->
        conn
        |> put_flash(:info, "Course updated successfully.")
        |> redirect(to: course_path(conn, :show, course))
      {:error, changeset} ->
        render(conn, "edit.html", course: course, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    course = Repo.get!(Course, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(course)

    conn
    |> put_flash(:info, "Course deleted successfully.")
    |> redirect(to: course_path(conn, :index))
  end
end
