defmodule PuppiesWeb.UserRegistrationController do
  use PuppiesWeb, :controller

  alias Puppies.{Accounts, Accounts.User, Utilities, IPStack}
  alias PuppiesWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    ip = Utilities.x_forward_or_remote_ip(conn)

    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        # Task.start(fn ->
        # Activities.sign_up(user)
        IPStack.process_ip(ip, user.id)
        # end)

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
