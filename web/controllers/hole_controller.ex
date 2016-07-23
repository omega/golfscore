defmodule Golf.HoleController do
  use Golf.Web, :controller

  alias Golf.Hole
  require Logger

  plug :scrub_params, "hole" when action in [:create, :update]
  plug :assign_course

  def new(conn, _params) do
    changeset =
      conn.assigns[:course]
      |> build_assoc(:holes)
      |> Hole.changeset()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"hole" => hole_params}) do
    changeset =
      conn.assigns[:course]
      |> build_assoc(:holes)
      |> Hole.changeset(hole_params)

    case Repo.insert(changeset) do
      {:ok, _hole} ->
        conn
        |> put_flash(:info, "Hole created successfully.")
        |> redirect(to: course_path(conn, :show, conn.assigns[:course]))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    hole = Repo.get!(assoc(conn.assigns[:course], :holes), id)
    |> Repo.preload(:course)
    render(conn, "show.html", hole: hole)
  end

  def edit(conn, %{"id" => id}) do
    hole = Repo.get!(assoc(conn.assigns[:course], :holes), id)
    changeset = Hole.changeset(hole)
    render(conn, "edit.html", hole: hole, changeset: changeset)
  end

  def update(conn, %{"id" => id, "hole" => hole_params}) do
    hole = Repo.get!(assoc(conn.assigns[:course], :holes), id)
    changeset = Hole.changeset(hole, hole_params)
    Logger.debug("#{inspect changeset}")
    case Repo.update(changeset) do
      {:ok, _hole} ->
        Logger.debug "updated hole!"
        conn
        |> put_flash(:info, "Hole updated successfully.")
        |> redirect(to: course_path(conn, :show, conn.assigns[:course]))
      {:error, changeset} ->
        render(conn, "edit.html", hole: hole, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    hole = Repo.get!(assoc(conn.assigns[:course], :holes), id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(hole)

    conn
    |> put_flash(:info, "Hole deleted successfully.")
    |> redirect(to: course_path(conn, :show, conn.assigns[:course]))
  end

  defp assign_course(conn, _opts) do
    case conn.params do
      %{"course_id" => course_id} ->
        case Repo.get(Golf.Course, course_id) do
          nil -> invalid_course(conn)
          course -> assign(conn, :course, course)
        end
      _ -> invalid_course(conn)
    end
  end

  defp invalid_course(conn) do
    conn
    |> put_flash(:error, "Invalid course!")
    |> redirect(to: page_path(conn, :index))
    |> halt
  end
end
