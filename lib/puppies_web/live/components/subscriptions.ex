defmodule PuppiesWeb.Subscriptions do
  use Phoenix.Component

  def subscription_wording(subscription_count) do
    if subscription_count == 1 do
      "subscription"
    else
      "subscriptions"
    end
  end

  def subscriptions(assigns) do
    ~H"""
      <div class="bg-white px-4 py-5 shadow sm:rounded-lg sm:px-6">
        <h2 id="timeline-title" class="text-xlg font-medium text-gray-900">Membership</h2>
        <%= if @subscription_count > 0 do %>
          <p class="mt-1 text-sm text-gray-500 text-sm">You currently have <%= @subscription_count %> active <%= subscription_wording(@subscription_count) %>.</p>
          <%= for subscription <- @active_subscriptions do %>
            <p class="mt-1 text-sm text-gray-500 text-sm">Your <span class="text-gray-600 font-semibold"><%= subscription.product.name %></span> membership is active until <span class="messages-date" data-time={Puppies.Utilities.integer_to_date(subscription.end_date)}></span></p>
          <% end %>

        <% else %>
          <p class="mt-1 text-sm text-gray-500 text-sm">To start listing choose a <%= live_redirect "plan", to: PuppiesWeb.Router.Helpers.live_path(@socket,  PuppiesWeb.ProductsLive), class: "underline cursor-pointer" %>.</p>

        <% end %>
      </div>
    """
  end
end
