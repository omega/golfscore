defmodule Golf.HoleControllerTest do
  use Golf.ConnCase

  alias Golf.Hole
  alias Golf.Course
  @valid_attrs %{num: 18, par: 3}
  @invalid_attrs %{}

  setup do
    {:ok, course} = create_course
    conn = conn()
    {:ok, conn: conn, course: course}
  end

  defp create_course do
    Course.changeset(%Course{}, %{name: "test course", map_link: "http://some/link"})
    |> Repo.insert
  end

  defp build_hole(course) do
    changeset =
      course
      |> build_assoc(:holes)
      |> Hole.changeset(@valid_attrs)
    Repo.insert!(changeset)
  end

  test "renders form for new resources", %{conn: conn, course: course} do
    conn = get conn, course_hole_path(conn, :new, course)
    assert html_response(conn, 200) =~ "New hole"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, course: course} do
    conn = post conn, course_hole_path(conn, :create, course), hole: @valid_attrs
    assert redirected_to(conn) == course_path(conn, :show, course)
    assert Repo.get_by(assoc(course, :holes), @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, course: course} do
    conn = post conn, course_hole_path(conn, :create, course), hole: @invalid_attrs
    assert html_response(conn, 200) =~ "New hole"
  end

  test "shows chosen resource", %{conn: conn, course: course} do
    hole = build_hole(course)
    conn = get conn, course_hole_path(conn, :show, course, hole)
    assert html_response(conn, 200) =~ "Show hole"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, course: course} do
    assert_error_sent 404, fn ->
      get conn, course_hole_path(conn, :show, course, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, course: course} do
    hole = build_hole(course)
    conn = get conn, course_hole_path(conn, :edit, course, hole)
    assert html_response(conn, 200) =~ "Edit hole"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, course: course} do
    hole = build_hole(course)
    conn = put conn, course_hole_path(conn, :update, course, hole), hole: @valid_attrs
    assert redirected_to(conn) == course_path(conn, :show, course)
    assert Repo.get_by(Hole, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, course: course} do
    hole = build_hole(course)
    conn = put conn, course_hole_path(conn, :update, course, hole), hole: %{"num" => nil}
    assert html_response(conn, 200) =~ "Edit hole"
  end

  test "deletes chosen resource", %{conn: conn, course: course} do
    hole = build_hole(course)
    conn = delete conn, course_hole_path(conn, :delete, course, hole)
    assert redirected_to(conn) == course_path(conn, :show, course)
    refute Repo.get(Hole, hole.id)
  end
end
