defmodule Golf.HoleControllerTest do
  use Golf.ConnCase

  alias Golf.Hole
  @valid_attrs %{num: 42, par: 42}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, hole_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing holes"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, hole_path(conn, :new)
    assert html_response(conn, 200) =~ "New hole"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, hole_path(conn, :create), hole: @valid_attrs
    assert redirected_to(conn) == hole_path(conn, :index)
    assert Repo.get_by(Hole, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, hole_path(conn, :create), hole: @invalid_attrs
    assert html_response(conn, 200) =~ "New hole"
  end

  test "shows chosen resource", %{conn: conn} do
    hole = Repo.insert! %Hole{}
    conn = get conn, hole_path(conn, :show, hole)
    assert html_response(conn, 200) =~ "Show hole"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, hole_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    hole = Repo.insert! %Hole{}
    conn = get conn, hole_path(conn, :edit, hole)
    assert html_response(conn, 200) =~ "Edit hole"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    hole = Repo.insert! %Hole{}
    conn = put conn, hole_path(conn, :update, hole), hole: @valid_attrs
    assert redirected_to(conn) == hole_path(conn, :show, hole)
    assert Repo.get_by(Hole, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    hole = Repo.insert! %Hole{}
    conn = put conn, hole_path(conn, :update, hole), hole: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit hole"
  end

  test "deletes chosen resource", %{conn: conn} do
    hole = Repo.insert! %Hole{}
    conn = delete conn, hole_path(conn, :delete, hole)
    assert redirected_to(conn) == hole_path(conn, :index)
    refute Repo.get(Hole, hole.id)
  end
end
