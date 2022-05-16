defmodule Puppies.ActivitiesTest do
  use Puppies.DataCase

  import Puppies.{ListingsFixtures, BreedFixtures, AccountsFixtures}
  alias Puppies.{Listings, Listings.Listing, Breeds, Activities}

  setup do
    affador = breed_fixture(%{name: "Afador", slug: "afador"})
    akita = breed_fixture(%{name: "Akita", slug: "akita"})
    shih_tzu = breed_fixture(%{name: "Shih Tzu", slug: "shih-tzu"})
    bulldog = breed_fixture(%{name: "Bulldog", slug: "bulldog"})
    user = user_fixture()
    buyer = user_fixture()

    listing =
      listing_fixture(%{
        user_id: user.id,
        listing_breeds: [%{breed_id: akita.id}, %{breed_id: affador.id}]
      })

    {:ok,
     user: user,
     buyer: buyer,
     listing: listing,
     dogs: %{akita: akita, shih_tzu: shih_tzu, affador: affador, bulldog: bulldog}}
  end

  describe "Activities" do
    test "check for diff in listing", %{user: user, listing: listing, dogs: dogs} do
      listing = Listings.get_listing!(listing.id)

      Listings.update_listing(listing, %{
        name: "updated name",
        price: "300",
        listing_breeds: [%{breed_id: dogs.shih_tzu.id}, %{breed_id: dogs.bulldog.id}]
      })

      after_listing = Listings.get_listing!(listing.id)
      changes = Activities.listing_changes(listing, after_listing)

      assert(
        changes == [
          %{field: :name, new_value: "updated name", old_value: "spike"},
          %{field: :price, new_value: 300, old_value: 500},
          %{
            field: :listing_breeds,
            new_value: ["Bulldog", "Shih Tzu"],
            old_value: ["Akita", "Afador"]
          }
        ]
      )
    end

    test "no changes to breed", %{user: user, listing: listing, dogs: dogs} do
      listing = Listings.get_listing!(listing.id)

      Listings.update_listing(listing, %{
        name: "test"
      })

      after_listing = Listings.get_listing!(listing.id)
      changes = Activities.listing_changes(listing, after_listing)
      assert(changes == [%{field: :name, new_value: "test", old_value: "spike"}])
    end

    test "no changes to photo", %{user: user, listing: listing, dogs: dogs} do
      listing = Listings.get_listing!(listing.id)

      Listings.update_listing(listing, %{
        name: "test"
      })

      after_listing = Listings.get_listing!(listing.id)
      changes = Activities.listing_changes(listing, after_listing)
      assert(changes == [%{field: :name, new_value: "test", old_value: "spike"}])
    end
  end
end
