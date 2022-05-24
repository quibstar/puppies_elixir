# defmodule Puppies.BlacklistsProcessor do
#   @moduledoc """
#   The Blacklists context.
#   """

#   import Ecto.Query, warn: false
#   alias Puppies.Repo
#   alias Puppies.Admin.{BlacklistedCountry, BlacklistedDomain}
#   alias Puppies.{Accounts, Flags, Blacklists}
#   # Check country

#   defp get_user(user_id) do
#     Accounts.User
#     |> Repo.get_by(id: user_id)
#   end

#   def check_users_country_origin(user_id) do
#     user =
#       get_user(user_id)
#       |> Repo.preload(:ip_addresses)

#     if user.status == "active" do
#       selected = Repo.all(from(c in BlacklistedCountry, where: c.selected == true))

#       map =
#         Enum.reduce(selected, %{}, fn country, acc ->
#           Map.put(acc, country.code, country.code)
#         end)

#       Enum.each(user.ip_addresses, fn x ->
#         if Map.has_key?(map, x.country_code) &&
#              !Flags.check_for_flag(%{"user_id" => user_id, "type" => "high_risk_country"}) do
#           Flags.create(%{
#             system_reported: true,
#             user_id: user.id,
#             reason: "User suspended. High risk country: #{x.country_name}",
#             fingerprint_id: 80
#           })

#           Accounts.update_user_status(user, "suspended")
#         end
#       end)
#     end
#   end

#   def check_user_email_for_banned_domain(user_id) do
#     user = get_user(user_id)

#     list = String.split(user.email, "@")
#     domain = List.last(list)

#     if Blacklists.domain_in_excluded_list(domain) &&
#          !Flags.check_for_flag(%{"user_id" => user_id, "type" => "high_risk_domain"}) do
#       Flags.create(%{
#         system_reported: true,
#         user_id: user.id,
#         reason: "User suspended. High risk domain: #{domain}",
#         fingerprint_id: 80
#       })

#       Accounts.update_user_status(user, "suspended")
#     end
#   end
# end
