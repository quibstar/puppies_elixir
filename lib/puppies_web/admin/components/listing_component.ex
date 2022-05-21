defmodule PuppiesWeb.Admin.ListingComponent do
  use Phoenix.Component
  use Phoenix.HTML

  def listings(assigns) do
    ~H"""
      <div class="min-w-full divide-y divide-gray-300">
        <%= for listing <- @listings do %>
          <div class="grid grid-cols-4 gap-2 py-2">
            <div class="col-span-1">
              <%= listing.name %>
            </div>

            <div class="col-span-1">
              $<%= listing.price %>.00
            </div>

            <div class="col-span-1">
              <%= listing.dob %>
            </div>

            <div class="col-span-1">
              <%= listing.sex %>
            </div>

            <%= unless is_nil(listing.description) do %>
              <div class="col-span-4">
                <div class="text-xs py-2">
                  <%= listing.description %>
                </div>
              </div>
            <% end %>
            <%= unless listing.photos == [] do %>
              <div class="col-span-4 p-2">
                <%= for photo <- listing.photos do %>
                  <%= img_tag photo.url, class: "inline-block h-16 w-16 rounded-full ring-2 ring-primary-500 ring-offset-1 mr-2" %>
                <% end %>
              </div>
            <% end %>
          </div>

        <% end %>
      </div>
    """
  end
end
