defmodule PuppiesWeb.FlatCard do
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

          <img src={@listing["business_photo"]} class="absolute -top-6 z-10 w-full object-cover w-12 h-12 rounded-full border-2 border-primary-500"/>

          <div class="mt-4 text-gray-500 text-sm">Listed by:
            <%= live_redirect @listing["business_name"], to: Routes.live_path(@socket, PuppiesWeb.BusinessPageLive, @listing["business_slug"]), class: "underline cursor-pointer"%>
          </div>

            <%= live_patch @listing["name"], to: Routes.live_path(@socket, PuppiesWeb.ListingShow, @listing["id"]), class: "underline text-primary-600 hover:text-primary-900" %>

            <div class="text-gray-500 text-sm">
              <div class="inline-block">
                <%= if @listing["purebred"] do %>
                  Purebred
                <% else %>
                  Mixed (<%= @listing["breeds_name"] %>)
                <% end%>
                <div class="inline-block"><%= @listing["sex"] %></div>
                <div><%= @listing["dob"] %></div>
                <div><%= @listing["id"] %></div>
              </div>
            </div>
        </div>
      </div>
    """
  end
end
