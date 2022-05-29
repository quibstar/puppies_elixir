defmodule Puppies.Activities do
  alias Puppies.Repo

  alias Puppies.{
    Listings.Listing,
    Businesses.Business,
    Accounts.User,
    Activity,
    Reviews.Review,
    UserSettings
  }

  def listing_changes(old_resource, new_resource) do
    listing_fields = Listing.__schema__(:fields) -- [:inserted_at, :updated_at]
    listing_changes = changes(old_resource, new_resource, listing_fields)

    breed_changes = breed_changes(old_resource, new_resource, :listing_breeds)
    listing_changes ++ breed_changes
  end

  def business_changes(old_resource, new_resource) do
    business_fields = Business.__schema__(:fields) -- [:inserted_at, :updated_at]
    listing_changes = changes(old_resource, new_resource, business_fields)
    breed_changes = breed_changes(old_resource, new_resource, :business_breeds)
    listing_changes ++ breed_changes
  end

  def changes(old_resource, new_resource, fields) do
    Enum.reduce(fields, [], fn field, acc ->
      if Map.get(old_resource, field) != Map.get(new_resource, field) do
        list = check_for_redacted(field, old_resource, new_resource)

        acc ++ list
      else
        acc
      end
    end)
  end

  defp check_for_redacted(field, old_resource, new_resource) do
    if field == :hashed_password do
      [
        %{
          field: field,
          old_value: "Redacted",
          new_value: "Redacted"
        }
      ]
    else
      [
        %{
          field: field,
          old_value: Map.get(old_resource, field),
          new_value: Map.get(new_resource, field)
        }
      ]
    end
  end

  def breed_changes(old_resource, new_resource, schema) do
    listing_breeds =
      Enum.reduce(old_resource.breeds, [], fn breed, acc ->
        [breed.name | acc]
      end)

    after_listing_breeds =
      Enum.reduce(new_resource.breeds, [], fn breed, acc ->
        [breed.name | acc]
      end)

    if listing_breeds != after_listing_breeds do
      [
        %{
          field: schema,
          old_value: listing_breeds,
          new_value: after_listing_breeds
        }
      ]
    else
      []
    end
  end

  # user changes
  def user_changes(old, new) do
    fields = User.__schema__(:fields) -- [:inserted_at, :updated_at]
    changes(old, new, fields)
  end

  def review_changes(old, new) do
    fields = Review.__schema__(:fields) -- [:inserted_at, :updated_at]
    changes(old, new, fields)
  end

  def user_settings_changes(old, new) do
    fields = UserSettings.__schema__(:fields) -- [:inserted_at, :updated_at]
    changes(old, new, fields)
  end

  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end
end
