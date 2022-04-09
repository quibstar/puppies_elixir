defmodule PuppiesWeb.BusinessPageLive do
  use PuppiesWeb, :live_view

  alias Puppies.Accounts

  alias Puppies.{Businesses, Listings}

  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(params, session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    business = Businesses.get_business_by_slug(params["slug"])
    IO.inspect(business)
    listings = Listings.get_listings_by_user_id(business.user_id)
    {:ok, assign(socket, user: user, loading: false, business: business, listings: listings)}
  end

  def render(assigns) do
    ~H"""
      <div class="h-full max-w-7xl px-4 py-6 sm:px-6 lg:px-8">
        <%= if @loading do %>
          <%= live_component PuppiesWeb.LoadingComponent, id: "listing-loading" %>
        <% else %>
            <div class="flex">
              <%= img_tag @business.photo.url, class: " w-16 h-16 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1", alt: "Profile image"%>
              <div class="ml-4">
                <h3 class="font-bold text-xl text-gray-900 sm:text-2xl"><%= @business.name %></h3>
                <div class="inline-block text-sm text-gray-500">Specializing in: </div>
                <div class="inline-block">
                  <%= for breed <- @business.breeds do %>
                    <%= live_redirect breed.name, to: Routes.live_path(@socket, PuppiesWeb.BreedsShowLive, breed.slug), class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800"%>
                  <% end %>
                </div>
              </div>
            </div>
              <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4 my-4">
                <%= for listing <- @listings do %>
                  <div class='relative col-span-1 bg-white rounded-lg shadow  overflow-hidden'>
                    <%= if listing.photos != [] do %>
                      <img src={List.first(listing.photos).url } class="w-full z-0 object-cover h-52"/>
                    <% end %>
                    <div class="p-4 bg-white capitalize relative">
                        <%= live_patch listing.name, to: Routes.live_path(@socket, PuppiesWeb.ListingShow, listing.id), class: "underline text-primary-600 hover:text-primary-900" %>
                        <div class="text-gray-500 text-sm">
                          <div class="inline-block">
                            <%= if listing.purebred do %>
                              Purebred
                            <% else %>
                              Mixed (<%= Puppies.Utilities.breed_names(listing.breeds) %>)
                            <% end%>
                            <div class="inline-block"><%= listing.sex %></div>
                            <div><%= listing.dob %></div>
                          </div>
                        </div>
                    </div>
                  </div>
                <% end %>
              </div>
        <% end %>
      </div>
    """
  end
end
