defmodule PuppiesWeb.StateSearchCard do
  @moduledoc """
  Card for puppies
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class='relative col-span-1 bg-white rounded-lg shadow  overflow-hidden'>
        <%= if @listing["photos"] != [] do %>
          <img src={List.first(@listing["photos"])} class="w-full z-0 object-cover h-52"/>
        <% end %>
        <div class="p-4 bg-white capitalize relative">

          <%= unless is_nil(@user) do %>
            <img src={@listing["business_photo"]} class="absolute -top-6 z-10 w-full object-cover w-12 h-12 rounded-full border-2 border-primary-500"/>
            <div class="mt-4 text-gray-500 text-sm">Listed by:
              <%= live_redirect @listing["business_name"], to: Routes.live_path(@socket, PuppiesWeb.BusinessPageLive, @listing["business_slug"]), class: "underline cursor-pointer"%>
              <PuppiesWeb.Badges.reputation_level reputation_level={@listing["reputation_level"]} />
            </div>
          <% end %>
            <%= live_patch @listing["name"], to: Routes.live_path(@socket, PuppiesWeb.ListingShow, @listing["id"]), class: "underline text-primary-600 hover:text-primary-900" %>
            <div class="text-gray-500 text-sm">
              <div class="inline-block">
                <span class="font-semibold">$<%= @listing["price"] %>.00</span> -
                <%= if @listing["purebred"] do %>
                  Purebred
                <% else %>
                  Mixed (<%= @listing["breeds_name"] %>)
                <% end%>
                <div><%= Puppies.Utilities.date_format(@listing["dob"]) %></div>
                <div>Views:<%= @listing["views"] %></div>
              </div>
            </div>
        </div>
      </div>
    """
  end
end
