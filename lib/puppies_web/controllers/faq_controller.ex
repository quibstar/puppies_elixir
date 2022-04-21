defmodule PuppiesWeb.FaqController do
  use PuppiesWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html", page_title: "Frequently Asked Questions - ")
  end
end
