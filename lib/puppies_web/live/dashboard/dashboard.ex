defmodule PuppiesWeb.UserDashboardLive do
  use PuppiesWeb, :live_view

  alias Puppies.{Accounts, Listings, Views, Threads, Subscriptions}

  alias PuppiesWeb.{UI.Drawer, BusinessForm}

  def mount(_params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    user = Accounts.get_user_business_and_listings(user.id)
    data = Listings.get_active_listings_by_user_id(user.id)
    viewing_history = Views.my_views(user.id)
    on_hold = Listings.get_listing_by_user_id_and_status(user.id, "on hold")
    sold = Listings.get_listing_by_user_id_and_status(user.id, "sold")
    messages = Threads.get_user_communication_with_business(user.id)
    active_subscriptions = Subscriptions.get_user_active_subscriptions(user.customer_id)
    subscription_count = Subscriptions.user_subscription_count(user.customer_id)

    {:ok,
     assign(socket,
       user: user,
       loading: false,
       business: user.business,
       listings: data.listings,
       viewing_history: viewing_history.views,
       view_pagination: Map.get(viewing_history, :pagination, %{count: 0}),
       pagination: Map.get(data, :pagination, %{count: 0}),
       on_hold: on_hold,
       sold: sold,
       thread_businesses: messages.businesses,
       thread_listings: messages.listings,
       active_subscriptions: active_subscriptions,
       subscription_count: subscription_count
     )}
  end

  def handle_params(params, _uri, socket) do
    if (params["page"] || params["view_page"]) && socket.assigns.loading == false do
      data =
        Listings.get_active_listings_by_user_id(socket.assigns.user.id, %{
          limit: "12",
          page: Map.get(params, "page", "1"),
          number_of_links: 7
        })

      viewing_history =
        Views.my_views(socket.assigns.user.id, %{
          limit: "5",
          page: Map.get(params, "view_page", "1"),
          number_of_links: 7
        })

      socket =
        assign(
          socket,
          viewing_history: viewing_history.views,
          view_pagination: Map.get(viewing_history, :pagination, %{count: 0}),
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
    <div class="mb-4" x-data="{ show_drawer: false, show_modal: false }">
      <%= if @loading do %>
      <% else %>

        <Drawer.drawer key="show_drawer">
          <:drawer_title>
            Business/Personal Details
          </:drawer_title>
          <:drawer_body>
            <.live_component module={BusinessForm} id="form"  user={@user} />
          </:drawer_body>
        </Drawer.drawer>

        <div class="mt-4 max-w-3xl mx-auto px-4 sm:px-6 md:flex md:items-center md:justify-between md:space-x-5 lg:max-w-7xl lg:px-8">
          <div class="flex items-center space-x-5">
            <div class="flex-shrink-0">
              <%= PuppiesWeb.Avatar.show(%{business: @business, user: @user, square: "16", extra_classes: "text-4xl pt-0.5"}) %>
            </div>
            <div>
              <h1 class="text-2xl font-bold text-gray-900"><%= @user.first_name %> <%=@user.last_name%></h1>
              <%= if @user.is_seller && !is_nil(@business.slug) do %>
                <p class="text-sm font-medium text-gray-500">Profile Page:
                  <%= live_redirect @business.name, to: Routes.live_path(@socket, PuppiesWeb.BusinessPageLive, @business.slug), class: "text-gray-900 underline cursor-pointer"%>
                </p>
              <% end %>
              <PuppiesWeb.ReputationLevel.badge reputation_level={@user.reputation_level} />
            </div>
          </div>
          <div class="mt-6 flex flex-col-reverse justify-stretch space-y-4 space-y-reverse sm:flex-row-reverse sm:justify-end sm:space-x-reverse sm:space-y-0 sm:space-x-3 md:mt-0 md:flex-row md:space-x-3">
            <%= if @user.is_seller do %>
              <button type="button" x-on:click="show_drawer = !show_drawer" type="button" class="inline-flex items-center justify-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-offset-gray-100 focus:ring-blue-500">Business/Personal Details</button>
            <% end %>
          </div>
        </div>

        <div class="mt-8 max-w-3xl mx-auto grid grid-cols-1 gap-6 sm:px-6 lg:max-w-7xl lg:grid-flow-col-dense lg:grid-cols-3">
          <div class="space-y-6 lg:col-start-1 lg:col-span-2">
            <section aria-labelledby="applicant-information-title">
              <div class="bg-white shadow sm:rounded-lg">
                <div class="px-4 py-5 sm:px-6">
                  <h2 id="applicant-information-title" class="text-xlg leading-6 font-medium text-gray-900">Hello <%= @user.first_name %> <%= @user.last_name %></h2>
                  <%= if @listings == [] or @subscription_count == 0 or is_nil(@business) do %>
                    <%= PuppiesWeb.ListingRequirements.html(%{listings: @listings, business: @business, user: @user, subscription_count: @subscription_count, socket: @socket}) %>
                  <% end %>
                </div>
              </div>
            </section>

            <%= unless is_nil(@user.business) do %>

              <div class="bg-white shadow sm:rounded-lg" x-data="{ tab: 'available' }">
                <div class="flex justify-between p-4 pb-0">
                  <h2 id="applicant-information-title" class="text-xlg leading-6 font-medium text-gray-900">Listings</h2>
                  <%= live_patch "New Listing", to: Routes.live_path(@socket, PuppiesWeb.ListingsNew), class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
                </div>

                <div class="sm:hidden">
                  <label for="tabs" class="sr-only">Select a tab</label>
                  <!-- Use an "onChange" listener to redirect the user to the selected tab URL. -->
                  <select id="tabs" name="tabs" class="block w-full focus:ring-primary-500 focus:border-primary-500 border-gray-300 rounded-md">
                    <option>Available</option>
                    <option>On Hold</option>
                    <option>Sold</option>
                  </select>
                </div>
                <div class="hidden sm:block">
                  <div class="border-b border-gray-200">
                    <nav class="-mb-px flex" aria-label="Tabs">

                      <a :class="{ 'border-primary-500 text-primary-600': tab === 'available' }"  x-on:click.prevent="tab = 'available'" href="#" class="border-transparent text-gray-500 hover:text-gray-700 hover:text-gray-700 hover:border-gray-300 w-1/4 py-4 px-1 text-center border-b-2 font-medium text-sm">
                        Active
                        <%= if @pagination.count > 0 do %>
                          (<%= @pagination.count %>)
                        <% end %>
                      </a>

                      <a :class="{ 'border-primary-500 text-primary-600': tab === 'on-hold' }"  x-on:click.prevent="tab = 'on-hold'"  href="#" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 w-1/4 py-4 px-1 text-center border-b-2 font-medium text-sm">
                        On Hold/Sale Pending
                        <%= unless @on_hold == [] do %>
                          (<%= length(@on_hold ) %>)
                        <% end %>
                      </a>
                      <a :class="{ 'border-primary-500 text-primary-600': tab === 'sold' }"  x-on:click.prevent="tab = 'sold'"  href="#" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 w-1/4 py-4 px-1 text-center border-b-2 font-medium text-sm" aria-current="page">
                        Sold
                        <%= unless @sold == [] do %>
                          (<%= length(@sold ) %>)
                        <% end %>
                      </a>
                    </nav>
                  </div>
                </div>
                <div class="px-4 py-5 sm:px-6">
                  <div x-show="tab === 'available'" >
                    <%= live_component PuppiesWeb.ListingsActive, id: "available-listing", listings: @listings, listing: nil, pagination: @pagination  %>
                  </div>
                  <div x-show="tab === 'on-hold'" >
                    <%= live_component PuppiesWeb.ListingsOnHold, id: "on-hold-listing", listings: @on_hold %>
                  </div>
                  <div x-show="tab === 'sold'" >
                    <%= live_component PuppiesWeb.ListingsSold, id: "sold-listing", listings: @sold %>
                  </div>
                </div>
              </div>

            <% end %>

            <%= unless @user.is_seller do %>
              <%= live_component PuppiesWeb.BuyerMessages, id: "buyer-messages", thread_businesses: @thread_businesses, thread_listings: @thread_listings, user: @user %>
            <% end %>
          </div>

          <section aria-labelledby="timeline-title" class="space-y-4">
            <%= PuppiesWeb.Subscriptions.subscriptions(%{active_subscriptions: @active_subscriptions, socket: @socket, subscription_count: @subscription_count}) %>

            <!-- Reputation -->
            <div class="border rounded p-4 bg-white space-y-2">
                <span class='text-lg leading-6 font-medium text-gray-900'>Reputation Level: </span>
                <%= cond do %>
                    <% @user.reputation_level == 3 -> %>
                        <div class="inline-block px-4 text-sm rounded-full bg-gold mb-1 text-white">Gold</div>
                        <div class="text-sm">You have unlimited access.</div>

                    <% @user.reputation_level == 2 -> %>
                        <div class="inline-block  px-2 text-sm rounded-full bg-silver mb-1 text-white">Silver</div>

                    <% @user.reputation_level == 1 -> %>
                        <div class="leading-6 inline px-2 text-sm rounded-full bg-bronze mb-1 text-white">Bronze</div>

                    <% @user.reputation_level == 0 -> %>
                       <div class="text-sm text-gray-600">You need to verify your email establish Bronze reputation and be visible to the community.</div>

                <% end %>
                <div class="mt-2">
                    <%= live_redirect "My Verifications", to: Routes.live_path(@socket, PuppiesWeb.VerificationsLive), class: "inline-block px-4 py-2 border border-transparent text-xs rounded shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500" %>
                    <div class="text-sm text-gray-600">Check and update your verifications.</div>
                </div>
            </div>

            <%= PuppiesWeb.ViewHistoryComponent.show(%{viewing_history: @viewing_history, view_pagination: @view_pagination, socket: @socket}) %>

            <%= live_component PuppiesWeb.WatchListComponent, id: "watch_list", listings: @user.favorite_listings %>

             <%= if !@user.is_seller do %>
              <div class="bg-white px-4 py-5 shadow sm:rounded-lg sm:px-6">
                <h2 id="timeline-title" class="text-xlg font-medium text-gray-900">Want to List?</h2>
                <p class="mt-1 max-w-2xl text-gray-500 text-sm">If you want to post a listing you must first:</p>
                <ol class="my-2 text-gray-500 list-decimal ml-4 text-sm">
                  <li>Update your <%= live_redirect "profile", to: Routes.live_path(@socket, PuppiesWeb.UserProfile), class: "underline" %> to become a lister</li>
                  <li>Verify your email</li>
                  <li>Fill out Business/Personal Details</li>
                  <li>Verify your phone (optional). Silver status. </li>
                  <li>Verify your ID (optional). Gold status.</li>
                  <li>Choose your plan</li>
                  <li>Create some listing!</li>
                </ol>
              </div>
             <% end %>

          </section>
        </div>
      <% end %>
    </div>
    """
  end
end
