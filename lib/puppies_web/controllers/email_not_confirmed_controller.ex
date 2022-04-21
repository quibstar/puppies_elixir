defmodule PuppiesWeb.EmailNotConfirmedController do
  use PuppiesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
