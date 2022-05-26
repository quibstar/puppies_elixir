defmodule Puppies.MessagesTest do
  use Puppies.DataCase

  import Puppies.ListingsFixtures
  import Puppies.AccountsFixtures
  import Puppies.BusinessesFixtures
  import Puppies.ThreadsFixtures
  import Ecto
  alias Puppies.Messages
  alias Puppies.Threads

  setup do
    seller = user_fixture()
    buyer = user_fixture()
    business = business_fixture(%{user_id: seller.id, location_autocomplete: "some place"})
    listing = listing_fixture(%{user_id: seller.id})

    thread =
      thread_fixture(%{
        uuid: Ecto.UUID.generate(),
        sender_id: seller.id,
        listing_id: listing.id,
        receiver_id: buyer.id,
        business_id: business.id
      })

    {:ok, thread: thread, seller: seller, buyer: buyer, business: business}
  end

  describe "Messages" do
    test "create new messages", %{
      thread: thread,
      seller: seller,
      buyer: buyer,
      business: business
    } do
      message = %{
        received_by: seller.id,
        sent_by: buyer.id,
        thread_id: thread.id,
        message: "What is up!",
        business_id: business.id
      }

      Messages.create_message(message)
      threads = Threads.get_user_threads(seller.id)
      thread = List.first(threads)
      message = List.first(thread.messages)
    end
  end
end
