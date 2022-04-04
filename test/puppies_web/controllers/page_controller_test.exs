defmodule PuppiesWeb.PageControllerTest do
  use PuppiesWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Trending Puppies"
  end
end
