defmodule Puppies.ReindexListingBackgroundJob do
  use Oban.Worker, queue: :events
  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"listing_id" => listing_id}}) do
    Puppies.ES.Listings.re_index_listing(listing_id)

    :ok
  end
end

defmodule Puppies.ReindexListingByUserIdBackgroundJob do
  use Oban.Worker, queue: :events
  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id}}) do
    Puppies.ES.Listings.re_index_listings_by_user_id(user_id)
    :ok
  end
end
