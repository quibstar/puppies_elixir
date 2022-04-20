defmodule PuppiesWeb.ListingsActive do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component
  alias Puppies.Utilities
  alias PuppiesWeb.{UI.Drawer, Stats}

  def listings_sum(listings) do
    Enum.reduce(listings, 0, fn x, acc ->
      x.price + acc
    end)
  end

  def handle_event("show-stats", %{"id" => listing_id}, socket) do
    listing =
      Enum.find(socket.assigns.listings, fn listing ->
        listing.id == String.to_integer(listing_id)
      end)

    {:noreply,
     assign(socket,
       listing: listing
     )}
  end

  def render(assigns) do
    ~H"""
      <section aria-labelledby="applicant-information-title" x-data="{ show_drawer: false, show_modal: false }">
        <Drawer.drawer key="show_drawer">
          <:drawer_title>
          </:drawer_title>
          <:drawer_body>
            <.live_component module={Stats} id="stats"  listing={@listing} />
          </:drawer_body>
        </Drawer.drawer>



        <%= if @listings == [] do %>
          <p class="mt-1 max-w-2xl text-gray-500">You currently don't have any listings. Let's get started</p>
        <% else %>
            <table class="min-w-full divide-y divide-gray-300">
              <thead>
                <tr>
                  <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6 md:pl-0">Name</th>
                  <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Price</th>
                  <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Status</th>
                  <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Views</th>
                  <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Messages</th>
                  <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6 md:pr-0">
                    <span class="sr-only">Edit</span>
                  </th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">

              <%= for listing <- @listings do %>
                <tr>
                  <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm text-gray-900 sm:pl-6 md:pl-0">
                    <%= if !is_nil(Utilities.first_image(listing.photos)) do %>
                      <%= img_tag Utilities.first_image(listing.photos), class: "inline-block h-10 w-10 rounded-full ring-2 ring-primary-500 ring-offset-1" %>
                    <% end %>
                    <%= live_patch listing.name, to: Routes.live_path(@socket, PuppiesWeb.ListingShow, listing.id), class: "ml-2 text-primary-600 hover:text-primary-900" %>
                  </td>
                  <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">$<%= listing.price %>.00</td>
                  <td class="whitespace-nowrap py-4 px-3 text-sm capitalize">
                    <%= live_patch listing.status, to: Routes.live_path(@socket, PuppiesWeb.ListingsStatusUpdateForm, listing.id), class: "underline ml-2 text-green-600 hover:text-green-900" %>
                  </td>
                  <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">
                    <%= if listing.views > 0 do %>
                      <span x-on:click.debounce="show_drawer = !show_drawer" class="cursor-pointer underline" phx-click="show-stats" phx-value-id={listing.id} phx-target={@myself} >
                        <%= listing.views %>
                      </span>
                    <% else %>
                      <%= listing.views %>
                    <% end %>
                  </td>
                  <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">
                    0
                  </td>
                  <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm sm:pr-6 md:pr-0">
                    <%= live_patch "Edit Listing", to: Routes.live_path(@socket, PuppiesWeb.ListingsEdit, listing.id), class: "text-primary-600 hover:text-primary-900" %>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>
          <div class="pt-4 text-lg text-gray-500 flex justify-between  border-t border-gray-300">
            <div>Potential earnings</div>
            <div>$<%= listings_sum(@listings) %>.00</div>
          </div>
          <%= if @pagination.count > 12 do %>
              <%= live_component PuppiesWeb.PaginationComponent, id: "pagination", pagination: @pagination, socket: @socket, params: %{"page" => @pagination.page, "limit" => @pagination.limit}, end_point: PuppiesWeb.UserDashboardLive, segment_id: nil %>
          <% end %>
        <% end %>

      </section>
    """
  end
end
