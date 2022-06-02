defmodule PuppiesWeb.UserSettingsController do
  use PuppiesWeb, :controller

  alias Puppies.Settings
  alias Puppies.UserSettings

  def edit(conn, _params) do
    us = Settings.get_user_settings(conn.assigns.current_user.id)

    user_settings =
      if is_nil(us) do
        %UserSettings{}
      else
        us
      end

    changeset = Settings.change_user_settings(user_settings)

    render(conn, "edit.html", changeset: changeset)
  end

  def create(conn, params) do
    %{"user_settings" => user_settings} = params
    us = Map.merge(user_settings, %{"user_id" => conn.assigns.current_user.id})

    case Settings.create_user_settings(us) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Setting updated.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def update(conn, params) do
    %{"user_settings" => user_settings} = params
    us = Settings.get_user_settings(conn.assigns.current_user.id)

    case Settings.update_user_settings(us, user_settings) do
      {:ok, user_settings} ->
        Puppies.BackgroundJobCoordinator.re_index_user(user_settings.user_id)

        conn
        |> put_flash(:info, "Setting updated.")
        |> redirect(to: Routes.user_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end
end
