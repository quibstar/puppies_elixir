defmodule PuppiesWeb.ListingShow do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_view

  alias Puppies.Accounts

  alias Puppies.{Listings, Businesses}

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
    business = Businesses.get_business_by_user_id(listing.user_id)

    photos =
      Enum.reduce(listing.photos, [], fn photo, acc ->
        if false do
          acc
        else
          [photo.url | acc]
        end
      end)

    {:ok,
     assign(socket,
       loading: false,
       user: user,
       listing: listing,
       current_photo: List.first(photos),
       photos: photos,
       business: business,
       page_title: "#{business.name} #{listing.name} - "
     )}
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8" x-data="{ modal: false, showMessage: false, showFlag: false, showBlock: false }">

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
            <%= live_component  PuppiesWeb.Details, id: "user_listing", listing: @listing, user: @user, business: @business %>
            <%= live_component  PuppiesWeb.ImageViewer, id: "image_viewer", photos: @photos, current_photo: @current_photo %>
          </div>
        <% end %>
      </div>
    """
  end
end
