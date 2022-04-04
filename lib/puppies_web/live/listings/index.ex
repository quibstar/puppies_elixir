defmodule PuppiesWeb.ListingsIndex do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <section aria-labelledby="applicant-information-title">
        <div class="bg-white shadow sm:rounded-lg">
          <div class="px-4 py-5 sm:px-6">
            <div class="flex justify-between">
              <h2 id="applicant-information-title" class="text-lg leading-6 font-medium text-gray-900">Listings</h2>
              <%= live_patch "New Listing", to: Routes.live_path(@socket, PuppiesWeb.ListingsNew), class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
            </div>
            <%= if @listings == [] do %>
              <p class="mt-1 max-w-2xl text-gray-500">You currently don't have any listings. Let's get started</p>
            <% else %>
                <table class="min-w-full divide-y divide-gray-300">
                  <thead>
                    <tr>
                      <th scope="col" class="py-3.5 pl-4 pr-3 text-left text-sm font-semibold text-gray-900 sm:pl-6 md:pl-0">Name</th>
                      <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Price</th>
                      <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Breeds</th>
                      <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Views</th>
                      <th scope="col" class="py-3.5 px-3 text-left text-sm font-semibold text-gray-900">Messages</th>
                      <th scope="col" class="relative py-3.5 pl-3 pr-4 sm:pr-6 md:pr-0">
                        <span class="sr-only">Edit</span>
                      </th>
                    </tr>
                  </thead>
                  <tbody class="divide-y divide-gray-200">

                  <%= for  listing <- @listings do %>
                      <tr>
                        <td class="whitespace-nowrap py-4 pl-4 pr-3 text-sm font-medium text-gray-900 sm:pl-6 md:pl-0">
                          <%= live_patch listing.name, to: Routes.live_path(@socket, PuppiesWeb.ListingShow, listing.id), class: "text-primary-600 hover:text-primary-900" %>
                        </td>
                        <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">$<%= listing.price %>.00</td>
                        <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500"><%= Puppies.Utilities.breed_names(listing.breeds)%></td>
                        <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">0</td>
                        <td class="whitespace-nowrap py-4 px-3 text-sm text-gray-500">
                          0
                        </td>
                        <td class="relative whitespace-nowrap py-4 pl-3 pr-4 text-right text-sm font-medium sm:pr-6 md:pr-0">
                          <%= live_patch "Edit Listing", to: Routes.live_path(@socket, PuppiesWeb.ListingsEdit, listing.id), class: "text-primary-600 hover:text-primary-900" %>
                        </td>
                      </tr>
                  <% end %>
                </tbody>
              </table>
            <% end %>
          </div>
        </div>
      </section>
    """
  end
end
