defmodule PuppiesWeb.Review do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component
  alias Puppies.Utilities

  def render(assigns) do
    ~H"""
    <div class="space-y-4 ">
      <div class="space-y-2 border rounded bg-white p-4">
        <div class="flex text-gray-500">
          <%= PuppiesWeb.Avatar.show(%{business: nil, user: @review.user, square: "16", extra_classes: "text-4xl pt-0.5"}) %>
          <div class="ml-3 flex-grow">
            <p class="font-medium text-gray-900"><%= @review.user.first_name %> <%= String.first(@review.user.last_name) %>.</p>
            <div class="flex">
              <PuppiesWeb.Stars.rating rating={@review.rating} />
            </div>
          </div>
          <div>
            <%= Puppies.DistanceOfTimeHelpers.time_ago_in_words(@review.inserted_at) %> ago
          </div>
        </div>
        <div class="text-sm text-gray-500 relative">
          <%= if Utilities.character_count(@review.review) > 350 do %>
            <div x-data="{ open: false, show_text: 'Show More', hide_text: 'Show Less' }">
              <div :class="open ? '' : 'h-24'" class="overflow-hidden relative">
                <%= raw(Utilities.new_lines_to_br_tags(@review.review)) %>
              </div>
                <div class="absolute bottom-0 bg-white w-full py-2">
                  <div class="underline cursor-pointer text-primary-600" x-on:click="open = ! open" x-text="open ? hide_text : show_text"></div>
                </div>
            </div>
          <% else %>
            <%= raw(Utilities.new_lines_to_br_tags(@review.review)) %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
