defmodule PuppiesWeb.Capabilities do
  use Phoenix.Component
  use Phoenix.HTML

  def available_readout(count, available) do
    available_count = length(available)

    if count - available_count >= 0 do
      "You have #{count - available_count} listings available."
    end
  end

  def show(assigns) do
    ~H"""
      <div class="text-gray-700 text-sm mt-2">
        <%= cond do %>
           <% @user.reputation_level == 3 -> %>
              As a Gold member you're entitled to communicate with anyone on the site.

            <% @user.reputation_level == 2 -> %>
              As a Silver member you're entitled to communicate with Silvers and Bronze members.

            <% @user.reputation_level == 1 -> %>
              As a Bronze member you are entitled to talk with only Bronze members.

            <% @user.reputation_level == 0 -> %>
              You need to verify your email before you can communicate with anyone on the site.
        <% end %>
        <%= if @user.is_seller do %>
          <%= for subscription <- @active_subscriptions do %>
            <%= if subscription.product.name == "Premium" do %>
              <p class="mt-1 text-sm text-gray-500 text-sm">Your <span class="text-gray-600 font-semibold"><%= subscription.product.name %></span> membership allows you 50 active listings.
              <%= available_readout(50, @available) %>
              </p>
            <% end %>
            <%= if subscription.product.name == "Standard" do %>
              <p class="mt-1 text-sm text-gray-500 text-sm">Your <span class="text-gray-600 font-semibold"><%= subscription.product.name %></span> membership allows you 25 active listings.
                <%= available_readout(25, @available) %>
              </p>
            <% end %>
          <% end %>
        <% end %>
      </div>
    """
  end
end
