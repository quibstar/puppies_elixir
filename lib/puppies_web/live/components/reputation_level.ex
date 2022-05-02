defmodule PuppiesWeb.ReputationLevel do
  use Phoenix.Component

  def badge(assigns) do
    ~H"""
    <%= cond do %>
      <% @reputation_level == 0 -> %>
        <span class="inline-block px-2 text-xs rounded-full bg-yellow-500 text-center mb-1 text-white">No Reputation</span>
      <% @reputation_level == 1 -> %>
        <span class="inline-block px-2 text-xs rounded-full bg-bronze text-center mb-1 text-white">Bronze</span>
      <% @reputation_level == 2 -> %>
        <span class="inline-block px-2 text-xs rounded-full bg-silver text-center mb-1 text-white">Silver</span>
      <% @reputation_level == 3-> %>
        <span class="inline-block px-2 text-xs rounded-full bg-gold text-center mb-1 text-white">Gold</span>
    <% end %>
    """
  end
end
