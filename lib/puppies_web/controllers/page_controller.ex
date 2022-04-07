defmodule PuppiesWeb.PageController do
  use PuppiesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html",
      page_title: "A better way to find a friend online - ",
      popular_breeds: Puppies.PopularBreeds.list_popular_breeds()
    )
  end
end
