defmodule PuppiesWeb.SitemapController do
  use PuppiesWeb, :controller
  plug(:put_layout, false)

  def index(conn, _params) do
    url_list = Puppies.SiteMap.puppies_city_state()
    city_state_breed = Puppies.SiteMap.site_map_generator()

    conn
    |> put_resp_content_type("text/xml")
    |> render("index.xml", url_list: url_list, city_state_breed: city_state_breed)
  end
end
