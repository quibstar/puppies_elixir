defmodule Puppies.BackgroundJobCoordinator do
  alias Puppies.{Listings, Businesses, Accounts}

  ##################################
  # Session                        #
  ##################################
  def session(user_id, first_name, last_name, email, ip, message) do
    %{user_id: user_id, ip: ip}
    |> Puppies.BlacklistCountryIPAddressBackgroundJob.new()
    |> Oban.insert()

    %{user_id: user_id, email: email}
    |> Puppies.BlacklistEmailBackgroundJob.new()
    |> Oban.insert()

    %{
      user_id: user_id,
      action: "Sign in",
      description: "#{first_name} #{last_name} #{message}."
    }
    |> Puppies.RecordActivityBackgroundJob.new()
    |> Oban.insert()

    %{ip: ip, user_id: user_id}
    |> Puppies.RecordIPBackgroundJob.new()
    |> Oban.insert()
  end

  def logout(user) do
    unless is_nil(user) do
      %{
        user_id: user.id,
        action: "Sign out",
        description: "#{user.first_name} #{user.last_name} signed out."
      }
      |> Puppies.RecordActivityBackgroundJob.new()
      |> Oban.insert()
    end
  end

  ##################################
  # User                           #
  ##################################
  def user_reset_password(user_id, first_name, last_name) do
    %{
      user_id: user_id,
      action: "Password reset",
      description: "#{first_name} #{last_name} reset their password with a reset token."
    }
    |> Puppies.RecordActivityBackgroundJob.new()
    |> Oban.insert()
  end

  def record_email_activity(original_user) do
    user = Accounts.get_user!(original_user.id)
    data = Puppies.Activities.user_changes(original_user, user)

    %{
      user_id: user.id,
      action: "Email update",
      description:
        "#{user.first_name} #{user.last_name} updated their email from within the app.",
      data: data
    }
    |> Puppies.RecordActivityBackgroundJob.new()
    |> Oban.insert()
  end

  def record_password_activity(original_user, user) do
    data = Puppies.Activities.user_changes(original_user, user)

    %{
      user_id: user.id,
      action: "Password update",
      description: "#{user.first_name} #{user.last_name} updated their password.",
      data: data
    }
    |> Puppies.RecordActivityBackgroundJob.new()
    |> Oban.insert()
  end

  def record_profile_activity(original_user, user) do
    data = Puppies.Activities.user_changes(original_user, user)

    %{
      user_id: user.id,
      action: "Profile update",
      description: "#{user.first_name} #{user.last_name} updated their profile.",
      data: data
    }
    |> Puppies.RecordActivityBackgroundJob.new()
    |> Oban.insert()

    check_for_blacklisted_phone(user.id, user.phone_number)
  end

  def re_index_user(user_id) do
    %{
      user_id: user_id
    }
    |> Puppies.ReindexUserBackgroundJob.new()
    |> Oban.insert()
  end

  ##################################
  # Listings                       #
  ##################################
  def record_new_listing_activity(saved_results) do
    case saved_results do
      {:ok, listing} ->
        %{
          user_id: listing.user_id,
          action: "Listing created",
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
          action: "Listing updated",
          description: "Listing updated: #{updated_listing.name}, ID: #{updated_listing.id}",
          data: Puppies.Activities.listing_changes(listing, updated_listing)
        }
        |> Puppies.RecordActivityBackgroundJob.new()
        |> Oban.insert()
    end
  end

  def re_index_listing(listing_id) do
    %{
      listing_id: listing_id
    }
    |> Puppies.ReindexListingBackgroundJob.new()
    |> Oban.insert()
  end

  def re_index_listing_by_user_id(user_id) do
    %{
      user_id: user_id
    }
    |> Puppies.ReindexListingByUserIdBackgroundJob.new()
    |> Oban.insert()
  end

  ##################################
  # Business                       #
  ##################################
  def record_new_business_activity(saved_results) do
    case saved_results do
      {:ok, business} ->
        updated_business = Businesses.get_business(business.id)

        %{
          user_id: updated_business.user_id,
          action: "Business created",
          description:
            "New business created: #{updated_business.name}, ID: #{updated_business.id}"
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
          action: "Business updated",
          description: "Business updated: #{updated_business.name}, ID: #{updated_business.id}",
          data: Puppies.Activities.business_changes(business, updated_business)
        }
        |> Puppies.RecordActivityBackgroundJob.new()
        |> Oban.insert()
    end
  end

  ##################################
  # View Count                     #
  ##################################
  def update_view_count_by_registered_user(user_id, listing_id) do
    %{user_id: user_id, listing_id: listing_id}
    |> Puppies.ViewBackgroundJob.new()
    |> Oban.insert()
  end

  def update_view_count_by_anonymous_user(listing_id) do
    %{user_id: nil, listing_id: listing_id}
    |> Puppies.ViewBackgroundJob.new()
    |> Oban.insert()
  end

  ##################################
  # Content Blacklist              #
  ##################################
  def check_for_blacklisted_content(user_id, content, area) do
    %{
      user_id: user_id,
      content: content,
      area: area
    }
    |> Puppies.RecordContentBackgroundJob.new()
    |> Oban.insert()
  end

  ##################################
  # Phone Blacklist              #
  ##################################
  def check_for_blacklisted_phone(user_id, phone_number) do
    %{
      user_id: user_id,
      phone_number: phone_number
    }
    |> Puppies.RecordPhoneBackgroundJob.new()
    |> Oban.insert()
  end

  ##################################
  # Reviews                        #
  ##################################
  def record_new_review_activity(user_id, review) do
    %{
      user_id: user_id,
      action: "Review created",
      description: "Review created. ID: #{review.id}"
    }
    |> Puppies.RecordActivityBackgroundJob.new()
    |> Oban.insert()
  end

  def record_updated_review_activity(user_id, review, new_review) do
    %{
      user_id: user_id,
      action: "Review updated",
      description: "Review updated. ID: #{review.id}",
      data: Puppies.Activities.review_changes(review, new_review)
    }
    |> Puppies.RecordActivityBackgroundJob.new()
    |> Oban.insert()
  end

  ##################################
  # Admin check content            #
  ##################################
  def admin_added_new_content(item, blacklist) do
    %{
      item: item,
      blacklist: blacklist
    }
    |> Puppies.CheckUsersAgainstBlacklistedItem.new()
    |> Oban.insert()
  end
end
