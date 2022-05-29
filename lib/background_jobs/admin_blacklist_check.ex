defmodule Puppies.CheckUsersAgainstBlacklistedItem do
  use Oban.Worker, queue: :events

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"item" => item, "blacklist" => blacklist}}) do
    case blacklist do
      "country" ->
        Puppies.BlacklistsProcessor.check_users_against_new_blacklist_country(item)
        :ok

      "content" ->
        Puppies.BlacklistsProcessor.check_users_listings_or_business_against_new_blacklist_content(
          item,
          Puppies.Listings.Listing,
          "listing description"
        )

        Puppies.BlacklistsProcessor.check_users_listings_or_business_against_new_blacklist_content(
          item,
          Puppies.Businesses.Business,
          "business description"
        )

        :ok

      "domain" ->
        Puppies.BlacklistsProcessor.check_users_against_new_blacklist_domain(item)
        :ok

      "ip_address" ->
        Puppies.BlacklistsProcessor.check_users_against_new_blacklist_ip(item)
        :ok

      "phone_number" ->
        Puppies.BlacklistsProcessor.check_against_new_blacklist_phone_number(item, "users")
        Puppies.BlacklistsProcessor.check_against_new_blacklist_phone_number(item, "business")
        :ok

      _ ->
        :ok
    end
  end
end
