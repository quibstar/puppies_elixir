defmodule PuppiesWeb.UserSessionController do
  use PuppiesWeb, :controller

  alias Puppies.{Accounts, Utilities}
  alias PuppiesWeb.UserAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    if user = Accounts.get_user_by_email_and_password(email, password) do
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
          ip = Utilities.x_forward_or_remote_ip(conn)
          # check blacklisted country, ip and email
          %{user_id: user.id, ip: ip}
          |> Puppies.BlacklistCountryIPAddressBackgroundJob.new()
          |> Oban.insert()

          %{user_id: user.id, email: user.email}
          |> Puppies.BlacklistEmailBackgroundJob.new()
          |> Oban.insert()

          %{
            user_id: user.id,
            action: "sign_in",
            description: "#{user.first_name} #{user.last_name} signed in."
          }
          |> Puppies.RecordActivityBackgroundJob.new()
          |> Oban.insert()

          %{ip: ip, user_id: user.id}
          |> Puppies.RecordIPBackgroundJob.new()
          |> Oban.insert()

          UserAuth.log_in_user(conn, user, user_params)
      end
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    user = conn.assigns.current_user

    unless is_nil(user) do
      %{
        user_id: user.id,
        action: "sign_out",
        description: "#{user.first_name} #{user.last_name} signed out."
      }
      |> Puppies.RecordActivityBackgroundJob.new()
      |> Oban.insert()
    end

    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
