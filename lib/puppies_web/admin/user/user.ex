defmodule PuppiesWeb.Admin.User do
  @moduledoc """
  User Profile
  """
  use PuppiesWeb, :live_view

  alias Puppies.{
    Admins,
    Accounts,
    Admin.Notes,
    Admin.Threads,
    Admin.Reviews,
    Admin.Flags,
    Admin.Listings,
    Admin.Business
  }

  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(%{"id" => id}, session, socket) do
    user = Accounts.get_user_business_and_listings(id)
    listings = Listings.get_user_listings(user.id)
    business = Business.get_user_business(user.id)
    notes = Notes.user_notes(user.id)
    reviews = Reviews.get_reviews_by_user(user.id)
    flags = Flags.flags_by_user_id(user.id)

    admin =
      if connected?(socket) && Map.has_key?(session, "admin_token") do
        %{"admin_token" => user_token} = session
        Admins.get_admin_by_session_token(user_token)
      end

    # UserThreads.get_thread_list(user.id)
    threads =
      if user.is_seller do
        Threads.seller_threads(user.id)
      else
        Threads.buyer_threads(user.id)
      end

    {:ok,
     assign(
       socket,
       loading: false,
       user: user,
       notes: notes,
       admin: admin,
       threads: threads,
       reviews: reviews,
       flags: flags,
       listings: listings,
       business: business
     )}
  end

  defp email_confirmed(confirmed_at) do
    if is_nil(confirmed_at) do
      "Not Confirmed"
    else
      Calendar.strftime(confirmed_at, "%m/%d/%y %I:%M:%S %p")
    end
  end

  def handle_event("resolve-flag", %{"flag_id" => flag_id}, socket) do
    flag =
      Enum.find(socket.assigns.flags, nil, fn flag ->
        if "#{flag.id}" == flag_id do
          flag
        end
      end)

    Flags.update(flag, %{
      resolved: true,
      admin_id: socket.assigns.admin.id
    })

    user = Accounts.get_user_business_and_listings(socket.assigns.user.id)

    {:noreply,
     assign(
       socket,
       user: user,
       loading: false
     )}
  end

  def render(assigns) do
    ~H"""
      <div>
        <%= if @loading do %>
          <%= live_component PuppiesWeb.LoadingComponent, id: "admin-loading" %>
        <% else %>
          <div class="mx-auto px-4 sm:px-6 md:px-8 py-4">
            <div class="md:grid grid-flow-col grid-cols-2 gap-2">
              <div>
                <div class="bg-white overflow-hidden shadow rounded-lg divide-y px-4">
                  <div class="px-4 py-5">
                    <div class="text-lg font-semibold mb-2">User</div>
                    <div class="flex">
                      <div>
                        <%= PuppiesWeb.Avatar.show(%{business: nil, user: @user, square: 10, extra_classes: "text-2xl"}) %>
                        <PuppiesWeb.ReputationLevel.badge reputation_level={@user.reputation_level} />
                      </div>

                      <div class="ml-3 space-y-1">
                        <p class="text-sm font-medium text-gray-900"><%= @user.first_name %> <%= @user.last_name %></p>
                        <p class="text-sm text-gray-500">ID: <%= @user.id %></p>
                        <p class="text-sm text-gray-500">Email: <%= @user.email %></p>
                        <p class="text-sm text-gray-500">Email confirmed: <%= email_confirmed(@user.confirmed_at) %></p>
                        <p class="text-sm text-gray-500">Phone: <%= @user.phone_number %></p>
                        <p class="text-sm text-gray-500">Is seller: <%= @user.is_seller %></p>
                        <div>
                          <p class="text-sm text-gray-500">Status: <%= @user.status %></p>
                        </div>
                        <p class="text-sm text-gray-500">Approved to sell: <%= @user.approved_to_sell %></p>
                        <p class="text-sm text-gray-500">Account locked: False</p>
                      </div>
                    </div>
                  </div>
                  <%= if @user.is_seller do %>
                    <div class="px-4 py-5">
                      <div class="text-lg font-semibold mb-2">Business</div>
                      <div class="flex">
                        <div class="flex-none">
                          <%= PuppiesWeb.Avatar.show(%{business: @business, user: @user, square: 10, extra_classes: "text-2xl"}) %>
                        </div>
                        <div class="ml-3 space-y-1">
                          <p class="text-sm font-medium text-gray-900"><%= @business.name %></p>
                          <p class="text-sm text-gray-500">Email website: <%= @business.website%></p>
                          <p class="text-sm text-gray-500">State license: <%= @business.state_license%></p>
                          <p class="text-sm text-gray-500">Fed license: <%= @business.federal_license%></p>
                          <p class="text-sm text-gray-500">Phone: <%= @business.phone%></p>
                          <p class="text-sm text-gray-500">Description: <%= @business.description %></p>
                          <p class="text-sm text-gray-500">Created on: <%= Calendar.strftime(@business.inserted_at , "%m/%d/%y %I:%M:%S %p")%></p>
                        </div>
                      </div>
                    </div>
                  <% end %>
                </div>
              </div>
              <div>
                <.live_component module={PuppiesWeb.Admin.Flags} id="flags" flags={@flags} />
                <div x-data="{ tab: 'listings' }" class="bg-white shadow rounded-lg p-4">
                  <div class="border-b border-gray-200">
                    <nav class="-mb-px flex space-x-2" aria-label="Tabs">
                      <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'notes' }" @click="tab = 'notes'">
                          Notes
                      </button>

                      <%= if @user.is_seller do %>
                        <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'listings' }" @click="tab = 'listings'">
                            Listings
                        </button>
                      <% end %>

                      <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'transactions' }" @click="tab = 'transactions'">
                          Transactions
                      </button>

                      <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'ip' }" @click="tab = 'ip'">
                          IP Address
                      </button>
                      <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'communications' }" @click="tab = 'communications'">
                          Communications
                      </button>
                    </nav>
                  </div>

                  <div x-show="tab === 'notes'">
                    <.live_component module={Puppies.Admin.NotesComponent} id="notes_component" notes={@notes} note={nil} user={@user} admin={@admin} />
                  </div>

                  <%= if @user.is_seller do %>
                    <div x-show="tab === 'listings'">
                      <.live_component module={Puppies.Admin.ListingsComponent} id="listings_component"  listings={@listings} />
                    </div>
                  <% end %>

                  <div x-show="tab === 'transactions'">
                    <.live_component module={PuppiesWeb.Admin.Transactions} id="transactions_component" user_id={@user.id}  customer_id={@user.customer_id}  admin={@admin} />
                  </div>

                  <div x-show="tab === 'ip'">
                    Ip info
                  </div>

                  <div x-show="tab === 'communications'">
                    <.live_component module={PuppiesWeb.Admin.Communications} id="communications", threads={@threads} user={@user} reviews={@reviews}/>
                  </div>
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    """
  end
end
