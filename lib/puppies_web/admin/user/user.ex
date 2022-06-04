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
    Admin.Business,
    Admin.Activities
  }

  @limit "20"
  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(%{"id" => id}, session, socket) do
    user = Accounts.get_user_business_and_listings(id)
    changeset = Accounts.change_user_profile(user)
    listings = Listings.get_user_listings(user.id)
    business = Business.get_user_business(user.id)
    notes = Notes.user_notes(user.id)
    reviews = Reviews.get_reviews_by_user(user.id)
    flags = Flags.flags_by_user_id(user.id)

    data =
      Activities.get_activities(user.id, %{
        limit: @limit,
        page: "1",
        number_of_links: 7
      })

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
       business: business,
       changeset: changeset,
       activities: data.activities,
       pagination: Map.get(data, :pagination, %{count: 0}),
       page: "1",
       limit: @limit
     )}
  end

  defp status_confirmed(confirmed_at) do
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
    flags = Flags.flags_by_user_id(user.id)

    {:noreply,
     assign(
       socket,
       user: user,
       flags: flags
     )}
  end

  def handle_event("update_user_status", %{"user" => params}, socket) do
    user = Accounts.update_status(socket.assigns.user, params)

    case user do
      {:ok, user} ->
        changeset = Accounts.change_user_profile(user)
        reindex_user_listings(user.id)

        {
          :noreply,
          socket
          |> put_flash(:info, "Status updated to #{user.status}")
          |> assign(:changeset, changeset)
          |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.Admin.User, user.id))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("update_locked_status", %{"user" => params}, socket) do
    user = Accounts.update_user_locked_status(socket.assigns.user, params)

    case user do
      {:ok, user} ->
        changeset = Accounts.change_user_profile(user)

        if user.locked do
          Accounts.admin_logout_user(user)
        end

        reindex_user_listings(user.id)

        {
          :noreply,
          socket
          |> put_flash(:info, "Account is locked: #{user.locked}")
          |> assign(:changeset, changeset)
          |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.Admin.User, user.id))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("update_user_selling_status", %{"user" => params}, socket) do
    user = Accounts.update_user_selling_status(socket.assigns.user, params)

    case user do
      {:ok, user} ->
        changeset = Accounts.change_user_profile(user)

        status =
          if user.approved_to_sell do
            "approved"
          else
            "un-approved"
          end

        reindex_user_listings(user.id)

        {
          :noreply,
          socket
          |> put_flash(:info, "Selling status updated to: #{status}")
          |> assign(:changeset, changeset)
          |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.Admin.User, user.id))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  defp reindex_user_listings(user_id) do
    Puppies.BackgroundJobCoordinator.re_index_listing_by_user_id(user_id)
  end

  def render(assigns) do
    ~H"""
      <div>
        <%= if @loading do %>
          <%= live_component PuppiesWeb.LoadingComponent, id: "admin-loading" %>
        <% else %>
          <div class="mx-auto px-4 sm:px-6 md:px-8 py-4">
            <div class="lg:grid md:grid-cols-2 gap-4">
              <div>
                <div class="bg-white overflow-hidden shadow rounded-lg divide-y px-4">
                  <div class="px-4 py-5">
                    <div class="text-lg font-semibold mb-2">User</div>
                    <div class="flex">
                      <div>
                        <%= PuppiesWeb.Avatar.show(%{business: nil, user: @user, square: 10, extra_classes: "text-2xl"}) %>
                        <PuppiesWeb.Badges.reputation_level reputation_level={@user.reputation_level} />
                      </div>

                      <div class="ml-3 space-y-1">
                        <p class="text-sm font-medium text-gray-900"><%= @user.first_name %> <%= @user.last_name %></p>
                        <p class="text-sm text-gray-500">ID: <%= @user.id %></p>
                        <p class="text-sm text-gray-500">Email: <%= @user.email %></p>
                        <p class="text-sm text-gray-500">Email confirmed: <%= status_confirmed(@user.confirmed_at) %></p>
                        <p class="text-sm text-gray-500">Phone: <%= @user.phone_number %></p>
                      </div>
                    </div>
                  </div>
                  <div class="px-4 py-5">
                    <.form let={f} for={@changeset}  phx_change="update_user_status">
                      <div class="my-2">
                        <div class="text-lg font-semibold mb-2">Status</div>
                        <div class="space-y-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-10">
                          <div class="flex items-center">
                            <%= radio_button(f, :status, :active, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300") %>
                            <label for="active" class="ml-3 block text-sm font-medium text-gray-700"> Active </label>
                          </div>

                          <div class="flex items-center">
                            <%= radio_button(f, :status, :suspended, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300") %>
                            <label for="sms" class="ml-3 block text-sm font-medium text-gray-700"> Suspended </label>
                          </div>
                        </div>
                        <div class="text-xs text-gray-500">
                          Suspended user are unable to access their dashboard and their listing will not be included in <strong>any</strong> searches until an admin makes a user active.
                        </div>

                      </div>
                    </.form>
                    <.form let={f} for={@changeset}  phx_change="update_locked_status">
                      <div>
                        <div class="text-lg font-semibold">Locked</div>
                        <div class="space-y-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-10">
                          <div class="flex items-center">
                            <%= radio_button(f, :locked, :false, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300") %>
                            <label for="sms" class="ml-3 block text-sm font-medium text-gray-700"> Unlocked </label>
                          </div>

                          <div class="flex items-center">
                            <%= radio_button(f, :locked, :true, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300") %>
                            <label for="sms" class="ml-3 block text-sm font-medium text-gray-700"> Locked </label>
                          </div>
                        </div>
                        <div class="text-xs text-gray-500">
                          Locked accounts will automatically log the user out. They will have to reset their password to regain access.
                        </div>
                      </div>
                    </.form>
                  </div>
                </div>
                <%= if @user.is_seller do %>
                  <div class="bg-white overflow-hidden shadow rounded-lg divide-y px-2 mt-4">
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
                          <p class="text-sm text-gray-500">Phone: <%= @business.phone_number %></p>
                          <p class="text-sm text-gray-500">Description: <%= @business.description %></p>
                          <p class="text-sm text-gray-500">Created on: <%= Calendar.strftime(@business.inserted_at , "%m/%d/%y %I:%M:%S %p")%></p>
                        </div>
                      </div>
                    </div>
                    <.form let={f} for={@changeset}  phx_change="update_user_selling_status", class="px-4 py-5">
                      <div class="text-lg font-semibold mb-2">Approved to sell</div>
                      <div class="space-y-4 sm:flex sm:items-center sm:space-y-0 sm:space-x-10">
                        <div class="flex items-center">
                          <%= radio_button(f, :approved_to_sell, :true, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300") %>
                          <label for="active" class="ml-3 block text-sm font-medium text-gray-700"> Yes </label>
                        </div>
                        <div class="flex items-center">
                          <%= radio_button(f, :approved_to_sell, :false, class: "focus:ring-primary-500 h-4 w-4 text-primary-600 border-gray-300") %>
                          <label for="sms" class="ml-3 block text-sm font-medium text-gray-700"> No </label>
                        </div>
                      </div>
                      <div class="text-xs text-gray-500">
                        Listings will not be included in any search if the business in not approved to sell.
                      </div>
                    </.form>
                  </div>
                <% end %>
                <.live_component module={Puppies.Admin.ActivitiesComponent} id="activities" activities={@activities} pagination={@pagination} page={@page} limit={@limit} user_id={@user.id} />
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
                    <.live_component module={PuppiesWeb.Admin.IpAddresses} id="ip_address" user={@user}  />
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
