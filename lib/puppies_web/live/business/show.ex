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
    data = Listings.get_active_listings_by_user_id(business.user_id)
    review_stats = Puppies.Reviews.review_stats(business.id)

    {:ok,
     assign(socket,
       user: user,
       loading: false,
       business: business,
       listings: data.listings,
       review_stats: review_stats,
       pagination: Map.get(data, :pagination, %{count: 0}),
       page_title: business.name
     )}
  end

  def handle_params(params, _uri, socket) do
    if params["page"] && socket.assigns.loading == false do
      data =
        Listings.get_active_listings_by_user_id(socket.assigns.business.user_id, %{
          limit: "12",
          page: params["page"],
          number_of_links: 7
        })

      socket =
        assign(
          socket,
          listings: data.listings,
          pagination: data.pagination
        )

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def render(assigns) do
    ~H"""
      <div class="h-full max-w-7xl px-4 py-6 sm:px-6 lg:px-8 mx-auto">
        <%= if @loading do %>
          <%= live_component PuppiesWeb.LoadingComponent, id: "listing-loading" %>
        <% else %>
          <div class="md:grid md:grid-cols-3 md:gap-4">
            <div>
              <%= live_component  PuppiesWeb.BusinessCard, id: "breeder_details",  user: @user, business: @business %>
              <%= unless @review_stats.average == 0 do %>
                <%= live_component  PuppiesWeb.ReviewStats, id: "listing_reviews", review_stats: @review_stats %>
              <% end %>
            </div>
            <div class="col-span-2 space-y-4">
              <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-4">
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

              <%= if @pagination.count > 12 do %>
                <%= live_component PuppiesWeb.PaginationComponent, id: "pagination", pagination: @pagination, socket: @socket, params: %{"page" => @pagination.page, "limit" => @pagination.limit}, end_point: PuppiesWeb.BusinessPageLive, segment_id: @business.slug %>
              <% end %>

              <%= unless @business.reviews == [] do %>
                <div class="font-bold text-xl text-gray-900 sm:text-2xl">Reviews</div>
                <%= for review <- @business.reviews do %>
                  <%= live_component  PuppiesWeb.Review, id: review.id, review: review, business: nil %>
                <% end %>
              <% end %>
            </div>
          </div>

        <% end %>
      </div>
    """
  end
end
