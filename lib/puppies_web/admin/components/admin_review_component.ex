defmodule PuppiesWeb.Admin.Review do
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
          <%= PuppiesWeb.Avatar.show(%{business: @review.business, user: @review.user, square: "10", extra_classes: "text-2xl pt-0.5"}) %>
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

        <%= unless is_nil(@review.reply) do %>
          <div class="text-sm my-4 text-gray-500">
            <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.Admin.User, @business.user.id), class: "underline" do %>
              <%= @business.name %> Reply
            <% end %>
            <%= @review.reply.reply %>
          </div>
        <% end %>

        <%= unless is_nil(@review.dispute) do %>
          <div class="inline-block bg-red-50 border-l-4 border-red-400 p-4 mt-2">
            <div class="flex">
              <div class="flex-shrink-0">
                <!-- Heroicon name: solid/exclamation -->
                <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                  <path fill-rule="evenodd" d="M8.257 3.099c.765-1.36 2.722-1.36 3.486 0l5.58 9.92c.75 1.334-.213 2.98-1.742 2.98H4.42c-1.53 0-2.493-1.646-1.743-2.98l5.58-9.92zM11 13a1 1 0 11-2 0 1 1 0 012 0zm-1-8a1 1 0 00-1 1v3a1 1 0 002 0V6a1 1 0 00-1-1z" clip-rule="evenodd" />
                </svg>
              </div>
              <div class="ml-3">
                <p class="text-sm text-red-700">
                  Comment left by <%= @review.user.first_name %> <%= @review.user.last_name %> is being disputed and is under review.
                </p>
              </div>
            </div>
          </div>
        <% end %>

        <div class="text-xs text-gray-500 mb-2">
          Approved: <%= @review.approved %>
        </div>

      </div>
    </div>
    """
  end
end
