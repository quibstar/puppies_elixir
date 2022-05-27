defmodule Puppies.ActivitiesBusinessTest do
  use Puppies.DataCase

  import Puppies.{BusinessesFixtures, BreedFixtures, AccountsFixtures}
  alias Puppies.{Businesses, Businesses.Business, Breeds, Activities}

  setup do
    affador = breed_fixture(%{name: "Afador", slug: "afador"})
    akita = breed_fixture(%{name: "Akita", slug: "akita"})
    shih_tzu = breed_fixture(%{name: "Shih Tzu", slug: "shih-tzu"})
    bulldog = breed_fixture(%{name: "Bulldog", slug: "bulldog"})
    user = user_fixture()
    buyer = user_fixture()

    business =
      business_fixture(%{
        user_id: user.id,
        name: "TEST Business",
        business_breeds: [%{breed_id: akita.id}, %{breed_id: affador.id}],
        location_autocomplete: "Grand Rapids"
      })

    {:ok,
     user: user,
     buyer: buyer,
     business: business,
     dogs: %{akita: akita, shih_tzu: shih_tzu, affador: affador, bulldog: bulldog}}
  end

  describe "Activities" do
    test "check for diff in business", %{user: user, business: business, dogs: dogs} do
      business = Businesses.get_business_by_user_id(user.id)

      Businesses.update_business(business, %{
        name: "Google",
        business_breeds: [%{breed_id: dogs.shih_tzu.id}, %{breed_id: dogs.bulldog.id}],
        location_autocomplete: "Grand Rapids"
      })

      updated_business = Businesses.get_business_by_user_id(user.id)
      changes = Activities.business_changes(business, updated_business)

      assert(
        changes == [
          %{field: :name, new_value: "Google", old_value: "TEST Business"},
          %{
            field: :business_breeds,
            new_value: ["Bulldog", "Shih Tzu"],
            old_value: ["Akita", "Afador"]
          }
        ]
      )
    end

    test "no changes to breed", %{user: user, business: business, dogs: dogs} do
      business = Businesses.get_business_by_user_id(user.id)

      Businesses.update_business(business, %{
        name: "test",
        location_autocomplete: "Grand Rapids"
      })

      updated_business = Businesses.get_business_by_user_id(user.id)
      changes = Activities.business_changes(business, updated_business)
      assert(changes == [%{field: :name, new_value: "test", old_value: "TEST Business"}])

      {:ok, res} =
        Activities.create_activity(%{user_id: user.id, action: "business_update", data: changes})

      assert(res.action == "business_update")
      assert(res.data == changes)
    end

    # test "no changes to photo", %{user: user, business: business, dogs: dogs} do
    #   business = Businesses.get_business!(business.id)

    #   Businesses.update_business(business, %{
    #     name: "test"
    #   })

    #   updated_business = Businesses.get_business!(business.id)
    #   changes = Activities.business_changes(business, updated_business)
    #   assert(changes == [%{field: :name, new_value: "test", old_value: "TEST Business"}])
    # end
  end
end
