defmodule PuppiesWeb.PuppyAvatar do
  @moduledoc """
  list view component
  """
  use Phoenix.Component
  use Phoenix.HTML

  defp listing_photos(photos) do
    photo = List.first(photos)
    photo.url
  end

  def show(assigns) do
    ~H"""
      <div class="relative">
        <%= cond do %>
          <% @listing.photos != []-> %>
            <%= img_tag( listing_photos(@listing.photos), class: "#{@extra_classes} mx-auto h-#{@square} w-#{@square} rounded-full border border-2 border-primary-500 object-cover") %>

          <% true -> %>
            <div class={"#{@extra_classes} mx-auto w-#{@square} h-#{@square} rounded-full overflow-hidden ring-2 ring-yellow-500 ring-offset-1 bg-primary-500 text-white font-bold text-center leading-relaxed"}>
              <%= @listing.name |> String.first() %>
            </div>
        <% end %>
      </div>
    """
  end
end
