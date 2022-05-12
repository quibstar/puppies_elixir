defmodule PuppiesWeb.CheckUserStatus do
  @moduledoc """
  Plug for checking current user
  """
  @behaviour Plug

  import Plug.Conn, only: [halt: 1]
  import Phoenix.Controller
  alias PuppiesWeb.Router

  def init(options), do: options

  def call(conn, _opts) do
    if conn.assigns.current_user.status == "active" do
      conn
    else
      conn
      |> redirect(to: Router.Helpers.suspended_path(conn, :index))
      |> halt()
    end
  end
end
