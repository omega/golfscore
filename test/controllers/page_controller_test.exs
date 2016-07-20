defmodule Golf.PageControllerTest do
  use Golf.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Golfscore"
  end
end
