defmodule Puppies.Admin.Settings do
  @moduledoc """
  The Settings context.
  """
  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.{Accounts}

  def reset_all_users() do
    users = Repo.all(Accounts.User)

    Enum.each(users, fn user ->
      Accounts.update_status(user, %{status: "active"})
      Accounts.update_user_selling_status(user, %{approved_to_sell: true})
      Puppies.ES.Users.re_index_user(user.id)
      Puppies.ES.Listings.re_index_listings_by_user_id(user.id)
    end)
  end
end
