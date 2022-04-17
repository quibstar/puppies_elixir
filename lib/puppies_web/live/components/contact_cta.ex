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
                  You need to upgrade to communicate with <%= @business_or_listing.name %> about <%= @business_or_listing.name %>. Choose a [plan]that fits your needs.
                </p>
              </div>
            </div>
        <% end %>
    </div>
    """
  end
end
