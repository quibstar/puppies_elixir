defmodule Puppies.ViewBackgroundJob do
  use Oban.Worker, queue: :events

  alias Puppies.Views

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id, "listing_id" => listing_id}}) do
    if is_nil(user_id) do
      Views.create_view(%{listing_id: listing_id})
    else
      unique = Views.unique(user_id, listing_id)
      Views.create_view(%{user_id: user_id, listing_id: listing_id, unique: !unique})
    end

    Views.update_count(listing_id)
    :ok
  end
end
