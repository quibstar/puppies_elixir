defmodule Puppies.Admin.ListingsComponent do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component

  def update(assigns, socket) do
    listings = assigns.listings
    available = separate_listings(listings, "available")
    hold = separate_listings(listings, "hold")
    sold = separate_listings(listings, "sold")

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:available, available)
     |> assign(:hold, hold)
     |> assign(:sold, sold)}
  end

  def separate_listings(listings, status) do
    Enum.reduce(listings, [], fn listing, acc ->
      if listing.status == status do
        [listing | acc]
      else
        acc
      end
    end)
  end

  def render(assigns) do
    ~H"""
    <div x-data="{ tab: 'available' }">
      <div class="border-b border-gray-200">
          <nav class="-mb-px flex space-x-2" aria-label="Tabs">
            <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'available' }" @click="tab = 'available'">
              Available
              <%= if @available != [] do %>
                (<%= length(@available) %>)
              <% end %>
            </button>

            <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'hold' }" @click="tab = 'hold'">
              Hold/Sale Pending
              <%= if @hold != [] do %>
                (<%= length(@hold) %>)
              <% end %>
            </button>

            <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'sold' }" @click="tab = 'sold'">
              Sold
              <%= if @sold != [] do %>
                (<%= length(@sold) %>)
              <% end %>
            </button>
          </nav>
       </div>

        <div x-show="tab === 'available'">
            <PuppiesWeb.Admin.ListingComponent.listings  listings={@available} />
        </div>

        <div x-show="tab === 'hold'">
           <PuppiesWeb.Admin.ListingComponent.listings  listings={@hold} />
        </div>

        <div x-show="tab === 'sold'">
           <PuppiesWeb.Admin.ListingComponent.listings  listings={@sold} />
        </div>
    </div>
    """
  end
end
