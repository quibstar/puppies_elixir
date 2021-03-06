defmodule PuppiesWeb.ListingShow do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_view

  alias Puppies.{Accounts, Listings, Businesses, Favorites, Views, Threads}

  def mount(%{"listing_id" => listing_id}, session, socket) do
    case connected?(socket) do
      true -> connected_mount(listing_id, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(listing_id, session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    listing = Listings.get_listing(listing_id)

    user_id =
      if is_nil(user) do
        nil
      else
        user.id
      end

    if !is_nil(user) && user.id != listing.user_id do
      Puppies.BackgroundJobCoordinator.update_view_count_by_registered_user(user.id, listing.id)
    end

    if is_nil(user) do
      Puppies.BackgroundJobCoordinator.update_view_count_by_anonymous_user(listing.id)
    end

    business = Businesses.get_business_by_user_id(listing.user_id)
    review_stats = Puppies.Reviews.review_stats(business.id)

    photos =
      Enum.reduce(listing.photos, [], fn photo, acc ->
        if false do
          acc
        else
          [photo.url | acc]
        end
      end)

    views = Views.list_views(listing_id)

    conversation_started =
      if !is_nil(user) do
        Threads.conversation_started(user.id, listing.user_id, listing.id)
      else
        []
      end

    favorites =
      if !is_nil(user) do
        Favorites.is_favorite(user.id, listing.id)
      else
        false
      end

    {:ok,
     assign(socket,
       loading: false,
       user_id: user_id,
       user: user,
       listing: listing,
       current_photo: List.first(photos),
       photos: photos,
       business: business,
       page_title: "#{business.name} - #{listing.name} ",
       is_favorite: favorites,
       views: views,
       review_stats: review_stats,
       conversation_started: conversation_started
     )}
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <%= if @loading do %>
          <%= live_component PuppiesWeb.LoadingComponent, id: "listing-loading" %>
        <% else  %>
          <div class="my-2">
            <button onclick="history.back()" aria-label="Back to collection">
              <svg  xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 stroke-primary-500" fill="none" viewBox="0 0 24 24" stroke="#3b82f6">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
              </svg>
            </button>
          </div>

          <div class="md:grid md:grid-cols-3 md:gap-4">
            <%= live_component  PuppiesWeb.BreederDetails, id: "breeder_details", listing: @listing, user: @user, business: @business,  conversation_started: @conversation_started %>
            <%= live_component  PuppiesWeb.ImageViewer, id: "image_viewer", photos: @photos, current_photo: @current_photo %>
            <div>
              <%= if @review_stats.average > 0 do %>
                <%= live_component  PuppiesWeb.ReviewStats, id: @business.id, review_stats: @review_stats %>
              <% end %>
              <%= if !is_nil(@user) && @business.user.reputation_level > @user.reputation_level do %>
                <%= live_component  PuppiesWeb.ContactCTA, id: "contact_cta",  user: @user, business_or_listing: @business %>
              <% end %>
            </div>
            <%= live_component  PuppiesWeb.ListingDetails, id: "listing_details", user_id: @user.id, listing: @listing, views: @views, is_favorite: @is_favorite %>
          </div>
        <% end %>
      </div>
    """
  end
end
