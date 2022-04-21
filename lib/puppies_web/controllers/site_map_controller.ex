defmodule PuppiesWeb.SitemapController do
  use PuppiesWeb, :controller
  plug(:put_layout, false)

  def index(conn, _params) do
    # looking_for_a_room = ReputableRooms.SiteMap.looking_for_a_room()
    # has_a_room = ReputableRooms.SiteMap.has_for_a_room()

    conn
    |> put_resp_content_type("text/xml")
    |> render("index.xml", site_map: "site-map")
  end
end
