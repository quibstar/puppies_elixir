defmodule PuppiesWeb.LegalController do
  use PuppiesWeb, :controller

  def terms_of_service(conn, _params) do
    render(conn, "terms_of_service.html", page_title: "Terms of service - ")
  end

  def privacy(conn, _params) do
    render(conn, "privacy.html", page_title: "Privacy - ")
  end
end
