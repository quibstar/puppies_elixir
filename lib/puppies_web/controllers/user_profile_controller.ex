defmodule PuppiesWeb.UserProfileController do
  use PuppiesWeb, :controller

  alias Puppies.Accounts

  def edit(conn, _params) do
    changeset = Accounts.change_user_profile(conn.assigns.current_user)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, params) do
    %{"user" => user_params} = params
    user = conn.assigns.current_user

    case Accounts.update_user_profile(user, user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Personal information updated successfully.")
        |> redirect(to: Routes.user_profile_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
