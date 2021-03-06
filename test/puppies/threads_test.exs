defmodule Puppies.ThreadsTest do
  use Puppies.DataCase

  import Puppies.ListingsFixtures
  import Puppies.AccountsFixtures
  import Puppies.BusinessesFixtures
  import Ecto
  alias Puppies.Threads

  setup do
    seller = user_fixture()
    buyer = user_fixture()
    business = business_fixture(%{user_id: seller.id, location_autocomplete: "some place"})
    listing = listing_fixture(%{user_id: seller.id})

    {:ok, seller: seller, buyer: buyer, listing: listing, business: business}
  end

  describe "Threads" do
    test "create new thread", %{seller: s, buyer: buyer, listing: listing, business: business} do
      uuid = Ecto.UUID.generate()

      seller = %{
        uuid: uuid,
        sender_id: s.id,
        listing_id: listing.id,
        receiver_id: buyer.id,
        message: "test",
        business_id: business.id
      }

      buyer = %{
        uuid: uuid,
        sender_id: buyer.id,
        listing_id: listing.id,
        receiver_id: s.id,
        message: "test",
        business_id: business.id
      }

      {:ok, seller} = Threads.create_thread(seller)
      {:ok, buyer} = Threads.create_thread(buyer)

      assert(seller.uuid == buyer.uuid)
      assert(seller.listing_id == buyer.listing_id)
    end

    test "create new threads in one pass", %{
      seller: seller,
      buyer: buyer,
      listing: listing,
      business: business
    } do
      {:ok, res} =
        Threads.create_threads(%{
          "sender_id" => seller.id,
          "receiver_id" => buyer.id,
          "listing_id" => listing.id,
          "message" => "Let's talk!",
          "business_id" => business.id
        })

      assert(Map.has_key?(res, :buyer))
      assert(Map.has_key?(res, :seller))

      {:error, type, changeset, map} =
        Threads.create_threads(%{
          "sender_id" => nil,
          "receiver_id" => buyer.id,
          "listing_id" => listing.id,
          "message" => "Let's talk!",
          "business_id" => business.id
        })

      assert(changeset.valid? == false)
    end
  end
end
