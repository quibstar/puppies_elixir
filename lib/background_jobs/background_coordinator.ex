defmodule Puppies.BackgroundJobCoordinator do
  alias Puppies.{Listings, Businesses}

  def login(user, ip) do
    %{user_id: user.id, ip: ip}
    |> Puppies.BlacklistCountryIPAddressBackgroundJob.new()
    |> Oban.insert()

    %{user_id: user.id, email: user.email}
    |> Puppies.BlacklistEmailBackgroundJob.new()
    |> Oban.insert()

    %{
      user_id: user.id,
      action: "sign_in",
      description: "#{user.first_name} #{user.last_name} signed in."
    }
    |> Puppies.RecordActivityBackgroundJob.new()
    |> Oban.insert()

    %{ip: ip, user_id: user.id}
    |> Puppies.RecordIPBackgroundJob.new()
    |> Oban.insert()
  end

  def logout(user) do
    unless is_nil(user) do
      %{
        user_id: user.id,
        action: "sign_out",
        description: "#{user.first_name} #{user.last_name} signed out."
      }
      |> Puppies.RecordActivityBackgroundJob.new()
      |> Oban.insert()
    end
  end

  def record_new_listing_activity(listing) do
    case listing do
      {:ok, listing} ->
        %{
          user_id: listing.user_id,
          action: "listing_created",
          description: "New listing created: #{listing.name}, ID: #{listing.id}"
        }
        |> Puppies.RecordActivityBackgroundJob.new()
        |> Oban.insert()
    end
  end

  def record_updated_listing_activity(listing, saved_results) do
    case saved_results do
      {:ok, _} ->
        # To get associations
        updated_listing = Listings.get_listing(listing.id)

        %{
          user_id: updated_listing.user_id,
          action: "listing_updated",
          description: "Listing updated: #{updated_listing.name}, ID: #{updated_listing.id}",
          data: Puppies.Activities.listing_changes(listing, updated_listing)
        }
        |> Puppies.RecordActivityBackgroundJob.new()
        |> Oban.insert()
    end
  end

  def record_new_business_activity(saved_results) do
    case saved_results do
      {:ok, business} ->
        %{
          user_id: business.user_id,
          action: "business_created",
          description: "New business created: #{business.name}, ID: #{business.id}"
        }
        |> Puppies.RecordActivityBackgroundJob.new()
        |> Oban.insert()
    end
  end

  def record_updated_business_activity(business, saved_results) do
    case saved_results do
      {:ok, _} ->
        updated_business = Businesses.get_business(business.id)

        %{
          user_id: updated_business.user_id,
          action: "business_updated",
          description: "Business updated: #{updated_business.name}, ID: #{updated_business.id}",
          data: Puppies.Activities.business_changes(business, updated_business)
        }
        |> Puppies.RecordActivityBackgroundJob.new()
        |> Oban.insert()
    end
  end
end
