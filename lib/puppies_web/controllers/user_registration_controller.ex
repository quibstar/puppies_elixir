defmodule PuppiesWeb.UserRegistrationController do
  use PuppiesWeb, :controller

  alias Puppies.{Accounts, Accounts.User, Utilities, IPStack, Activities}
  alias PuppiesWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

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
          action: "sign_up",
          description: "#{user.first_name} #{user.last_name} signed up."
        }
        |> Puppies.RecordActivityBackgroundJob.new()
        |> Oban.insert()

        %{ip: ip, user_id: user.id}
        |> Puppies.RecordIPBackgroundJob.new()
        |> Oban.insert()

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
