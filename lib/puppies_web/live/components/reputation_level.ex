defmodule PuppiesWeb.ReputationLevel do
  use Phoenix.Component

  def badge(assigns) do
    ~H"""
    <div>
      <%= cond do %>
        <% @reputation_level == 0 -> %>
          <div class="inline-block px-2 text-xs rounded-full bg-yellow-500 text-center mb-1 text-white">No Reputation</div>
        <% @reputation_level == 1 -> %>
          <div class="inline-block px-2 text-xs rounded-full bg-bronze text-center mb-1 text-white">Bronze</div>
        <% @reputation_level == 2 -> %>
          <div class="inline-block px-2 text-xs rounded-full bg-silver text-center mb-1 text-white">Silver</div>
        <% @reputation_level == 3-> %>
          <div class="inline-block px-2 text-xs rounded-full bg-gold text-center mb-1 text-white">Gold</div>
      <% end %>
    </div>
    """
  end
end
