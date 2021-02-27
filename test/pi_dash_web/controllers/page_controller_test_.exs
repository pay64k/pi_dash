defmodule PiDashWeb.PageControllerTest do
  use PiDashWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "mountPoint"
  end
end
