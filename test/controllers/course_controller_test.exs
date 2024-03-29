defmodule Golf.CourseControllerTest do
  use Golf.ConnCase

  require Logger
  alias Golf.Course
  alias Golf.Hole
  
  @valid_attrs %{map_link: "some content", name: "some content", make_holes: "18"}
  @query_attrs %{map_link: "some content", name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, course_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing courses"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, course_path(conn, :new)
    assert html_response(conn, 200) =~ "New course"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, course_path(conn, :create), course: @valid_attrs
    assert redirected_to(conn) == course_path(conn, :index)
    course = Course
      |> Repo.get_by(@query_attrs)
      |> Repo.preload(:holes)
    assert course

    assert length(course.holes) == 18
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, course_path(conn, :create), course: @invalid_attrs
    assert html_response(conn, 200) =~ "New course"
  end

  test "shows chosen resource", %{conn: conn} do
    course = Repo.insert! %Course{}
    conn = get conn, course_path(conn, :show, course)
    assert html_response(conn, 200) =~ "Show course"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, course_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    course = Repo.insert! %Course{}
    conn = get conn, course_path(conn, :edit, course)
    assert html_response(conn, 200) =~ "Edit course"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    course = Repo.insert! %Course{}
    conn = put conn, course_path(conn, :update, course), course: @valid_attrs
    assert redirected_to(conn) == course_path(conn, :show, course)
    assert Repo.get_by(Course, @query_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    course = Repo.insert! %Course{}
    conn = put conn, course_path(conn, :update, course), course: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit course"
  end

  test "deletes chosen resource", %{conn: conn} do
    course = build_course(9)
    conn = delete conn, course_path(conn, :delete, course)
    assert redirected_to(conn) == course_path(conn, :index)
    refute Repo.get(Course, course.id)
  end

  defp build_course(holes) do
    changeset = Course.changeset(%Course{}, %{name: "Test course", map_link: "http://some/link"})

    course = Repo.insert!(changeset)

    for h <- 1..holes do
      cs = course
        |> build_assoc(:holes)
        |> Hole.changeset(%{num: h, par: 3})
      Repo.insert!(cs)
    end
    course
  end
end
