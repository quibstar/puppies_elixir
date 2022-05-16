defmodule Puppies.Activities do
  alias Puppies.{Listings.Listing}

  def listing_changes(old_listing, new_listing) do
    fields = Listing.__schema__(:fields)

    Enum.reduce(fields, [], fn field, acc ->
      if Map.get(old_listing, field) != Map.get(new_listing, field) do
        list = [
          %{
            field: field,
            old_value: Map.get(old_listing, field),
            new_value: Map.get(new_listing, field)
          }
        ]

        acc ++ list
      else
        acc
      end
    end) ++ breed_changes(old_listing, new_listing)
  end

  def breed_changes(old_listing, new_listing) do
    listing_breeds =
      Enum.reduce(old_listing.breeds, [], fn breed, acc ->
        [breed.name | acc]
      end)

    after_listing_breeds =
      Enum.reduce(new_listing.breeds, [], fn breed, acc ->
        [breed.name | acc]
      end)

    if listing_breeds != after_listing_breeds do
      [
        %{
          field: :listing_breeds,
          old_value: listing_breeds,
          new_value: after_listing_breeds
        }
      ]
    else
      []
    end
  end
end
