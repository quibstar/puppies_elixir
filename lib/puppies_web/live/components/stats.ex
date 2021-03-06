defmodule PuppiesWeb.Stats do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component
  alias Puppies.{Views, Utilities}

  def mount(_, socket) do
    {:ok, assign(socket, listing: nil, loading: true)}
  end

  def update(assigns, socket) do
    views =
      if is_nil(assigns.listing) do
        []
      else
        Views.list_views(assigns.listing.id)
      end

    view_users =
      if views == [] do
        []
      else
        Views.list_views_users(assigns.listing.id)
      end

    {:ok,
     assign(socket,
       listing: assigns.listing,
       loading: is_nil(assigns.listing),
       views: views,
       view_users: view_users
     )}
  end

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
      <div class='bg-white max-w-xl mx-auto'>
        <%= if @loading do %>
        <% else %>
          <%= unless is_nil(@listing) do %>
            <div class="text-center space-y-4 bg-white">
              <%= img_tag List.first(@listing.photos).url, class: "mx-auto w-44 h-44 rounded-full overflow-hidden object-cover block ring-2 ring-yellow-500 ring-offset-1", alt: "Profile image"%>
              <div>
                <div class="inline-block text-sm text-gray-500">Stats for:</div>
                <h3 class="font-bold text-xl text-gray-900"><%= @listing.name %></h3>
              </div>
                <div>
                  <dl class="mt-5 grid gap-2 grid-cols-2">
                    <div>
                      <dt class="text-sm font-medium text-gray-500 truncate">Total Views</dt>
                      <dd class="mt-1 text-2xl font-semibold text-gray-900"><%= length(@views) %></dd>
                    </div>

                    <div>
                      <dt class="text-sm font-medium text-gray-500 truncate">Unique Views</dt>
                      <dd class="mt-1 text-2xl font-semibold text-gray-900"><%= Utilities.unique(@views) %></dd>
                    </div>

                    <div>
                      <dt class="text-sm font-medium text-gray-500 truncate">Member Views</dt>
                      <dd class="mt-1 text-2xl font-semibold text-gray-900"><%= Utilities.members(@views) %></dd>
                    </div>

                    <div>
                      <dt class="text-sm font-medium text-gray-500 truncate">Non Registered Views</dt>
                      <dd class="mt-1 text-2xl font-semibold text-gray-900"><%= Utilities.organic(@views) %></dd>
                    </div>

                  </dl>
                </div>
              </div>
              <div>

            <div class="mt-6 font-bold text-xl text-gray-900">
              Viewed by:
            </div>
            <ul role="list" class="divide-y divide-gray-200">
              <%= for view <- @view_users do %>
                <li class="py-4 flex items-center">
                  <%= PuppiesWeb.Avatar.show(%{business: view.user.business, user: view.user, square: 10, extra_classes: "text-2xl"}) %>
                  <%= unless is_nil(view.user.business) do %>
                    <div class="ml-3 flex-grow">
                      <p class="text-sm font-medium text-gray-900">
                        <%= live_redirect view.user.business.name, to: Routes.live_path(@socket, PuppiesWeb.BusinessPageLive, view.user.business.slug), class: "underline cursor-pointer"%>
                      </p>
                      <p class="text-xs font-medium text-gray-500">
                        Registered Lister
                      </p>
                    </div>
                  <% else %>
                    <div class="ml-3 flex-grow">
                      <%= view.user.first_name %> <%= view.user.last_name %>
                      <p class="text-xs font-medium text-gray-500">
                        Registered Member.
                      </p>
                    </div>
                  <% end %>
                </li>
              <% end %>
            </ul>
              </div>
          <% end %>
        <% end %>
      </div>
    """
  end
end
