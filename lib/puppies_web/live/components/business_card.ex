defmodule PuppiesWeb.BusinessCard do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div>
        <div class="text-center space-y-4 bg-white px-6 py-9 border rounded">
          <%= img_tag @business.photo.url, class: "mx-auto w-44 h-44 rounded-full overflow-hidden object-cover block ring-2 ring-primary-500 ring-offset-1", alt: "Profile image"%>
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
      </div>
    """
  end
end
