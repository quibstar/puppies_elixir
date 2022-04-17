defmodule PuppiesWeb.ListingShow do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_view

  alias Puppies.{Accounts, Listings, Businesses, Favorites, Views}

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

    listing = Listings.get_listing!(listing_id)

    user_id =
      if is_nil(user) do
        nil
      else
        user.id
      end

    if !is_nil(user) && user.id != listing.user_id do
      %{user_id: user_id, listing_id: listing_id}
      |> Puppies.ViewBackgroundJob.new()
      |> Oban.insert()
    end

    if is_nil(user) do
      %{user_id: nil, listing_id: listing_id}
      |> Puppies.ViewBackgroundJob.new()
      |> Oban.insert()
    end

    favorites =
      if is_nil(user) do
        []
      else
        Favorites.get_favorite_ids(user.id)
      end

    business = Businesses.get_business_by_user_id(listing.user_id)

    photos =
      Enum.reduce(listing.photos, [], fn photo, acc ->
        if false do
          acc
        else
          [photo.url | acc]
        end
      end)

    views = Views.list_views(listing_id)

    {:ok,
     assign(socket,
       loading: false,
       user: user,
       listing: listing,
       current_photo: List.first(photos),
       photos: photos,
       business: business,
       page_title: "#{business.name} #{listing.name} - ",
       favorites: favorites,
       views: views
     )}
  end

  def handle_event("favorite", %{"listing_id" => listing_id}, socket) do
    user_id = socket.assigns.user.id
    listing_id = String.to_integer(listing_id)

    if Enum.member?(socket.assigns.favorites, listing_id) do
      Favorites.delete_favorite(user_id, listing_id)
    else
      Favorites.create_favorite(%{user_id: user_id, listing_id: listing_id})
    end

    socket =
      assign(
        socket,
        favorites: Favorites.get_favorite_ids(user_id)
      )

    {:noreply, socket}
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
            <%= live_component  PuppiesWeb.BreederDetails, id: "breeder_details", listing: @listing, user: @user, business: @business, favorites: @favorites %>
            <%= live_component  PuppiesWeb.ImageViewer, id: "image_viewer", photos: @photos, current_photo: @current_photo %>
            <div>
              <%= live_component  PuppiesWeb.ReviewStats, id: "listing_reviews" %>
            </div>
            <%= live_component  PuppiesWeb.ListingDetails, id: "listing_details", listing: @listing, views: @views %>
          </div>
        <% end %>
      </div>
    """
  end
end
