defmodule PuppiesWeb.UserSessionController do
  use PuppiesWeb, :controller

  alias Puppies.{Accounts, Utilities, IPStack}
  alias PuppiesWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
      ip = Utilities.x_forward_or_remote_ip(conn)

      # Activities.sign_in(user)
      IPStack.process_ip(ip, user.id)

      cond do
        user.status == "suspended" ->
          redirect(conn, to: Routes.suspended_path(conn, :index)) |> halt()

        user.status == "locked" ->
          Puppies.ES.Listings.re_index_listings_by_user_id(user.id)

          render(conn, "new.html",
            error_message:
              "Your account may have been compromised. Use the \"Forgot your password?\" link below to unlock account."
          )

        true ->
          UserAuth.log_in_user(conn, user, user_params)
      end
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
