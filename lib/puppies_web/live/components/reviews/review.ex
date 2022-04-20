defmodule PuppiesWeb.Review do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  def new_lines_to_br_tags(review) do
    String.replace(review, "\n", "<br />")
  end

  def character_count(text) do
    String.length(text)
  end

  def render(assigns) do
    ~H"""
    <div class="space-y-4 ">
      <div class="space-y-2 border rounded bg-white p-4">
        <div class="flex text-gray-500">
          <img class="h-10 w-10 rounded-full" src="https://images.unsplash.com/photo-1550525811-e5869dd03032?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=facearea&facepad=2&w=256&h=256&q=80" alt="">
          <div class="ml-3 flex-grow">
            <p class="font-medium text-gray-900"><%= @review.user.first_name %> <%= String.first(@review.user.last_name) %>.</p>
            <div class="flex">
              <%= live_component PuppiesWeb.Stars, rating: @review.rating %>
            </div>
          </div>
          <div>
            <%= Puppies.DistanceOfTimeHelpers.time_ago_in_words(@review.inserted_at) %> ago
          </div>
        </div>
        <div class="text-sm text-gray-500 relative">
          <%= if character_count(@review.review) > 350 do %>
            <div x-data="{ open: false, show_text: 'Show More', hide_text: 'Show Less' }">
              <div :class="open ? '' : 'h-24'" class="overflow-hidden relative">
                <%= raw(new_lines_to_br_tags(@review.review)) %>
              </div>
                <div class="absolute bottom-0 bg-white w-full py-2">
                  <div class="underline cursor-pointer text-primary-600" x-on:click="open = ! open" x-text="open ? hide_text : show_text"></div>
                </div>
            </div>
          <% else %>
            <%= raw(new_lines_to_br_tags(@review.review)) %>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
