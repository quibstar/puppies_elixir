defmodule PuppiesWeb.AdminRegistrationController do
  use PuppiesWeb, :controller

  alias Puppies.Admins
  alias Puppies.Admins.Admin
  alias PuppiesWeb.AdminAuth

  def new(conn, _params) do
    changeset = Admins.change_admin_registration(%Admin{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"admin" => admin_params}) do
    case Admins.register_admin(admin_params) do
      {:ok, admin} ->
        {:ok, _} =
          Admins.deliver_admin_confirmation_instructions(
            admin,
            &Routes.admin_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "Admin created successfully.")
        |> AdminAuth.log_in_admin(admin)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
