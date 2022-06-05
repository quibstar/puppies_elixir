defmodule PuppiesWeb.Admin.Communications do
  @moduledoc """
  empty data component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <div x-data="{ tab: 'conversations' }">
        <div class="border-b border-gray-200">
          <nav class="-mb-px flex space-x-2" aria-label="Tabs">
            <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'conversations' }" @click="tab = 'conversations'">
              Conversations
            </button>

            <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'reviews' }" @click="tab = 'reviews'">
              Reviews
            </button>

            <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'sys-email' }" @click="tab = 'sys-email'">
              System Emails
            </button>

            <button class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-2 px-1 border-b-2 font-medium text-sm" :class="{ 'active-tab': tab === 'sys-messages' }" @click="tab = 'sys-messages'">
              System Messages
            </button>

          </nav>
        </div>
        <div x-show="tab === 'conversations'">
          <.live_component module={PuppiesWeb.Admin.ThreadComponent} id="threads" threads={@threads} thread={nil} messages={[]} user={@user}/>
        </div>
        <div x-show="tab === 'sys-messages'">
          sys messages
        </div>

        <div x-show="tab === 'sys-email'">
          sys emails
        </div>

        <div x-show="tab === 'reviews'">
          <div class="my-4 text-xs text-gray-500">
            Reviews written by this user.
          </div>
          <div class="space-y-2">
            <%= for review <- @reviews do %>
              <%= live_component  PuppiesWeb.Review, id: review.id, review: review, business: review.business %>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
