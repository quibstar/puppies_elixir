defmodule PuppiesWeb.Capabilities do
  use Phoenix.Component
  use Phoenix.HTML

  def show(assigns) do
    ~H"""
      <div class="text-gray-700 text-sm mt-2">
        <%= cond do %>
           <% @reputation_level == 3 -> %>
              As a Gold member you're entitled to communicate with anyone on the site.

            <% @reputation_level == 2 -> %>
              As a Silver member you're entitled to communicate with Silvers and Bronze members.

            <% @reputation_level == 1 -> %>
              As a Bronze member you are entitled to talk with only Bronze members.

            <% @reputation_level == 0 -> %>
              You need to verify your email before you can communicate with anyone on the site.
        <% end %>
      </div>
    """
  end
end
