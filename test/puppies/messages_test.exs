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
    _business = business_fixture(%{user_id: seller.id, location_autocomplete: "some place"})
    listing = listing_fixture(%{user_id: seller.id})

    thread =
      thread_fixture(%{
        uuid: Ecto.UUID.generate(),
        user_id: seller.id,
        listing_id: listing.id
      })

    {:ok, thread: thread, seller: seller, buyer: buyer}
  end

  describe "Messages" do
    test "create new messages", %{thread: thread, seller: seller, buyer: buyer} do
      message = %{
        received_by: seller.id,
        sent_by: buyer.id,
        thread_id: thread.id,
        message: "What is up!"
      }

      Messages.create_message(message)
      threads = Threads.get_user_threads(seller.id)
      thread = List.first(threads)
      message = List.first(thread.messages)
      assert(message.sender.id == buyer.id)
    end
  end
end
