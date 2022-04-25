defmodule PuppiesWeb.ListingsSold do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component
  alias Puppies.Utilities

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

        <%= if @listings == [] do %>
          <p class="mt-1 max-w-2xl text-gray-500">You currently don't have any sold listings.</p>
        <% else %>
            <table class="min-w-full divide-y divide-gray-300">
              <thead>
                <tr>
                  <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6 md:pl-0">Name</th>
                  <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Price</th>
                  <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Status</th>
                  <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Views</th>
                </tr>
              </thead>
              <tbody class="divide-y divide-gray-200">

              <%= for listing <- @listings do %>
                <tr>
                  <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6 md:pl-0">
                    <%= if !is_nil(Utilities.first_image(listing.photos)) do %>
                      <%= img_tag Utilities.first_image(listing.photos), class: "inline-block h-10 w-10 rounded-full ring-2 ring-primary-500 ring-offset-1" %>
                    <% end %>
                    <%= live_patch listing.name, to: Routes.live_path(@socket, PuppiesWeb.ListingShow, listing.id), class: "ml-2 text-primary-600 hover:text-primary-900" %>
                  </td>
                  <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">$<%= listing.price %>.00</td>
                  <td class="whitespace-nowrap py-4 px-3 text-sm text-red-500 capitalize"><%= listing.status %></td>
                  <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">
                    <%= listing.views %>
                  </td>
                </tr>
              <% end %>
            </tbody>
          </table>
        <% end %>

      </section>
    """
  end
end
