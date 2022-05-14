defmodule PuppiesWeb.Admin.User do
  @moduledoc """
  User Profile
  """
  use PuppiesWeb, :live_view
  alias Puppies.{Admins, Accounts, Admin.Notes}

  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(%{"id" => id}, session, socket) do
    user = Accounts.get_user_business_and_listings(id)
    notes = Notes.user_notes(user.id)

    admin =
      if connected?(socket) && Map.has_key?(session, "admin_token") do
        %{"admin_token" => user_token} = session
        Admins.get_admin_by_session_token(user_token)
      end

    {:ok,
     assign(
       socket,
       loading: false,
       user: user,
       notes: notes,
       admin: admin
     )}
  end

  def render(assigns) do
    ~H"""
      <div>
        <%= if @loading do %>
          <%= live_component PuppiesWeb.LoadingComponent, id: "admin-loading" %>
        <% else %>
          <div class="max-w-7xl mx-auto px-4 sm:px-6 md:px-8 py-4">
            <div class="md:grid grid-flow-col grid-cols-2 gap-2">
              <!-- This example requires Tailwind CSS v2.0+ -->
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
                      <p class="text-sm text-gray-500">Email confirmed: <%= Calendar.strftime(@user.confirmed_at , "%m/%d/%y %I:%M:%S %p")%></p>
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
                        <%= PuppiesWeb.Avatar.show(%{business: @user.business, user: @user, square: 10, extra_classes: "text-2xl"}) %>
                      </div>
                      <div class="ml-3 space-y-1">
                        <p class="text-sm font-medium text-gray-900"><%= @user.business.name %></p>
                        <p class="text-sm text-gray-500">Email website: <%= @user.business.website%></p>
                        <p class="text-sm text-gray-500">State license: <%= @user.business.state_license%></p>
                        <p class="text-sm text-gray-500">Fed license: <%= @user.business.federal_license%></p>
                        <p class="text-sm text-gray-500">Phone: <%= @user.business.phone%></p>
                        <p class="text-sm text-gray-500">Description: <%= @user.business.description %></p>
                        <p class="text-sm text-gray-500">Created on: <%= Calendar.strftime(@user.business.inserted_at , "%m/%d/%y %I:%M:%S %p")%></p>
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>
              <div>
                <div x-data="{ tab: 'notes' }" class="bg-white px-2 shadow mt-2">
                  <div class="border-b border-gray-200">
                        <nav class="-mb-px flex space-x-2" aria-label="Tabs">
                          <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'notes' }" @click="tab = 'notes'">
                              Notes
                          </button>

                          <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'transactions' }" @click="tab = 'transactions'">
                              Transactions
                          </button>

                          <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'ip' }" @click="tab = 'ip'">
                              IP Address
                          </button>
                      </nav>
                      <div x-show="tab === 'notes'">
                        <.live_component module={Puppies.Admin.NotesComponent} id="notes_component" notes={@notes} note={nil} user={@user} admin={@admin} />
                      </div>
                      <div x-show="tab === 'transactions'">
                        transactions
                      </div>
                      <div x-show="tab === 'ip'">
                        Ip info
                      </div>
                  </div>
                </div>
                <div x-data="{ tab: 'activity' }" class="bg-white px-2 shadow mt-2">
                  <div class="border-b border-gray-200">
                    <nav class="-mb-px flex space-x-2" aria-label="Tabs">
                      <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'activity' }" @click="tab = 'activity'">
                          Activity
                      </button>

                      <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'conversations' }" @click="tab = 'conversations'">
                          Conversations
                      </button>

                      <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'sys-messages' }" @click="tab = 'sys-messages'">
                          System Messages
                      </button>
                    </nav>
                    <div x-show="tab === 'activity'">
                      Activity
                    </div>
                    <div x-show="tab === 'conversations'">
                      conversations
                    </div>
                    <div x-show="tab === 'sys-messages'">
                      sys messages
                    </div>
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
