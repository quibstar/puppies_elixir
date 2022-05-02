defmodule PuppiesWeb.ContactCTA do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
    <div >
        <%= if !is_nil(@user) && @user.id != @business_or_listing.user_id do %>
            <div class="bg-white mt-4 border rounded">
              <div class="px-4 py-5 sm:p-6">
                <h3 class="text-lg leading-6 font-medium text-gray-900">
                  Want to talk?
                </h3>
                <p class="text-sm text-gray-700">
                  You must be at or above the reputation level of <PuppiesWeb.ReputationLevel.badge reputation_level={@business_or_listing.user.reputation_level} /> to communicate with <%= @business_or_listing.name %> about <%= @business_or_listing.name %>.
                </p>
                <div class="mt-2">
                  <%= live_redirect "Level up!", to: Routes.live_path(@socket, PuppiesWeb.VerificationsLive), class: "inline-block px-4 py-2 border border-transparent text-xs rounded shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500" %>
                </div>
              </div>
            </div>
        <% end %>
    </div>
    """
  end
end
