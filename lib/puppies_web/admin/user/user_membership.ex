defmodule Puppies.Admin.UserMembership do
  @moduledoc """
  Admin history component
  """
  use PuppiesWeb, :live_component

  def subscription_wording(subscription_count) do
    if subscription_count == 1 do
      "subscription"
    else
      "subscriptions"
    end
  end

  def render(assigns) do
    ~H"""
      <div class="px-4 py-5">
        <div class="my-2">
          <div class="text-lg font-semibold mb-2">Membership</div>
          <%= if @subscription_count > 0 do %>
            <p class="mt-1 text-sm text-gray-500 text-sm">Their is currently <%= @subscription_count %> active <%= subscription_wording(@subscription_count) %>.</p>
            <%= for subscription <- @active_subscriptions do %>
              <p class="mt-1 text-sm text-gray-500 text-sm"><span class="text-gray-600 font-semibold"><%= subscription.product.name %></span> membership is active until <span class="messages-date" data-date={Puppies.Utilities.integer_to_date(subscription.end_date)}></span></p>
            <% end %>
          <% else %>
            <p class="mt-1 text-sm text-gray-500 text-sm">No membership.</p>
          <% end %>
        </div>
      </div>
    """
  end
end
