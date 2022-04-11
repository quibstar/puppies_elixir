defmodule PuppiesWeb.ListView do
  @moduledoc """
  list view component
  """
  use PuppiesWeb, :live_component
  alias Puppies.Utilities

  def render(assigns) do
    ~H"""
      <li class="py-4 flex">
        <%= if !is_nil(Utilities.first_image(@listing.photos)) do %>
          <%= img_tag Utilities.first_image(@listing.photos), class: "inline-block h-10 w-10 rounded-full ring-2 ring-primary-500 ring-offset-1" %>
        <% end %>
        <div class="ml-3">
          <p class="text-sm font-medium text-gray-900 underline">
            <%= live_patch @listing.name, to: Routes.live_path(@socket, PuppiesWeb.ListingShow, @listing.id) %>
          </p>
            <p class="text-sm text-gray-500"><%= live_redirect @listing.user.business.name, to: Routes.live_path(@socket, PuppiesWeb.BusinessPageLive, @listing.user.business.slug), class: "underline cursor-pointer"%></p>
        </div>
      </li>
    """
  end
end
