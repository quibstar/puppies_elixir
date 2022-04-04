# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Puppies.Repo.insert!(%Puppies.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
import Jason

alias Puppies.{
  Repo,
  Dogs,
  ListingStatus,
  Accounts,
  Accounts.User,
  Businesses,
  Photos,
  Location,
  Utilities
}

"#{__DIR__}/breeds.json"
|> File.read!()
|> Jason.decode!()
|> Enum.map(fn breed ->
  res = Dogs.create_breed(%{name: breed, slug: Utilities.string_to_slug(breed)})
end)

Enum.each(["available", "on hold", "sold"], fn opt ->
  %ListingStatus{}
  |> ListingStatus.changeset(%{status: opt})
  |> Repo.insert()
end)

{_, user} =
  Accounts.register_user(%{
    first_name: "Kris",
    last_name: "utter",
    email: "quibstar@gmail.com",
    password: "superSecret!",
    terms_of_service: true,
    is_seller: true
  })

{_, business} =
  Businesses.change_business(%Businesses.Business{}, %{
    name: "Mike's Kennel",
    slug: "mikes-kennels",
    website: "tes.com",
    phone: "616-555-5555",
    description: "test",
    state_license: false,
    federal_license: false,
    user_id: user.id,
    location_autocomplete: "Startop Drive, Montauk, New York 11954, United States"
  })
  |> Repo.insert()

Photos.change_photo(%Photos.Photo{}, %{
  url: "/uploads/6434c717-bd93-4bee-b57d-b2b4c56513c8.jpg",
  name: "31e687f4-d5cd-47c0-b7be-2f68e6fa5afd.jpg",
  business_id: business.id
})
|> Repo.insert()

Location.changeset(
  %Location{},
  %{
    place_id: "address.2388413043656068",
    place_name: "Startop Drive, Montauk, New York 11954, United States",
    place: "Montauk",
    place_slug: "montauk",
    region: "New York",
    region_slug: "new-york",
    region_short_code: "ny",
    country: "United States",
    text: "Startop Drive",
    delete: false,
    lat: "41.06365",
    lng: "-71.90411",
    business_id: business.id
  }
)
|> Repo.insert()

# todo create listings
