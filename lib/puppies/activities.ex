defmodule Puppies.Activities do
  alias Puppies.Repo
  alias Puppies.{Listings.Listing, Businesses.Business, Accounts.User, Activity}

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

  def create_activity(attrs \\ %{}) do
    %Activity{}
    |> Activity.changeset(attrs)
    |> Repo.insert()
  end

  # def sign_up(user) do
  #   create_activity(%{
  #     user_id: user.id,
  #     action: "sign_up",
  #     description: "#{user.first_name} #{user.last_name} registered a new account"
  #   })
  # end

  # def sign_in(user) do
  #   create_activity(%{
  #     user_id: user.id,
  #     action: "sign_in",
  #     description: "#{user.first_name} #{user.last_name} signed in"
  #   })
  # end

  # def sign_out(user) do
  #   create_activity(%{
  #     user_id: user.id,
  #     action: "sign_out",
  #     description: "#{user.first_name} #{user.last_name} signed out"
  #   })
  # end

  # def password_reset(user, description) do
  #   create_activity(%{
  #     user_id: user.id,
  #     action: "password_reset",
  #     description: "#{user.first_name} #{user.last_name} #{description}"
  #   })
  # end
end
