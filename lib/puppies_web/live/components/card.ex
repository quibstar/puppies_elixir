defmodule PuppiesWeb.Card do
  @moduledoc """
  Card for puppies
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class='relative col-span-1 bg-white rounded-lg shadow  overflow-hidden'>
        <%= if @listing.photos != [] do %>
          <img src={List.first(@listing.photos).url } class="w-full z-0 object-cover h-52"/>
        <% end %>
        <div class="p-4 bg-white capitalize relative">
          <%= unless is_nil(@user) do %>
            <img src={@listing.user.business.photo.url} class="absolute -top-6 z-10 w-full object-cover w-12 h-12 rounded-full border-2 border-primary-500"/>
            <div class="mt-4 text-gray-500 text-sm">Listed by:
              <%= live_redirect @listing.user.business.name, to: Routes.live_path(@socket, PuppiesWeb.BusinessPageLive, Puppies.Utilities.string_to_slug(@listing.user.business.name)), class: "underline cursor-pointer"%>
            </div>
          <% end %>
            <%= live_patch @listing.name, to: Routes.live_path(@socket, PuppiesWeb.ListingShow, @listing.id), class: "underline text-primary-600 hover:text-primary-900" %>
            <div class="text-gray-500 text-sm">
              <div class="inline-block">
                <%= if @listing.purebred do %>
                  Purebred
                <% else %>
                  Mixed (<%= Puppies.Utilities.breed_names(@listing.breeds) %>)
                <% end%>
                <div class="inline-block"><%= @listing.sex %></div>
                <div><%= Puppies.Utilities.date_format_from_ecto(@listing.dob) %></div>
              </div>
            </div>
        </div>
      </div>
    """
  end
end
