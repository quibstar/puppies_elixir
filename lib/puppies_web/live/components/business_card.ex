defmodule PuppiesWeb.BusinessCard do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div>
        <div class="text-center space-y-4 bg-white px-6 py-9 border rounded">
          <div>
            <%= PuppiesWeb.Avatar.show(%{business: @business, user: @business.user, square: 44, extra_classes: "text8_5xl"}) %>
            <div class="relative -mt-4 z-10">
              <PuppiesWeb.ReputationLevel.badge reputation_level={@user.reputation_level} />
            </div>
          </div>
          <div>
            <div class="inline-block text-sm text-gray-500">Presented by</div>
            <h3 class="font-bold text-xl text-gray-900 sm:text-2xl"><%= @business.name %></h3>
            <div class="inline-block text-sm text-gray-500">Specializing in: </div>
            <div class="inline-block">
              <%= for breed <- @business.breeds do %>
                <%= live_redirect breed.name, to: Routes.live_path(@socket, PuppiesWeb.BreedsShowLive, breed.slug), class: "inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-primary-100 text-primary-800"%>
              <% end %>
            </div>
          </div>
        </div>
         <div class="bg-white px-6 py-9 border rounded my-4">
          <div class="text-gray-900 font-bold">About: <%= @business.name %></div>
          <div class="text-sm text-gray-500"><%= @business.description %></div>
        </div>
      </div>
    """
  end
end
