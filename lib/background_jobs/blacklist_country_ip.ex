defmodule Puppies.BlacklistCountryIPAddressBackgroundJob do
  use Oban.Worker, queue: :blacklist

  alias Puppies.BlacklistsProcessor

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id, "ip" => ip}}) do
    BlacklistsProcessor.check_users_country_origin(user_id)
    BlacklistsProcessor.check_for_banned_ip_address(user_id, ip)
    :ok
  end
end
