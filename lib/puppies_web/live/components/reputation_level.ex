defmodule PuppiesWeb.Badges do
  use Phoenix.Component

  def reputation_level(assigns) do
    ~H"""
    <%= cond do %>
      <% @reputation_level == 0 -> %>
        <span class="inline-block px-2 text-xs rounded-full bg-primary-500 text-center mb-1 text-white">No Rep</span>
      <% @reputation_level == 1 -> %>
        <span class="inline-block px-2 text-xs rounded-full bg-bronze text-center mb-1 text-white">Bronze</span>
      <% @reputation_level == 2 -> %>
        <span class="inline-block px-2 text-xs rounded-full bg-silver text-center mb-1 text-white">Silver</span>
      <% @reputation_level == 3-> %>
        <span class="inline-block px-2 text-xs rounded-full bg-gold text-center mb-1 text-white">Gold</span>
    <% end %>
    """
  end

  def user_type(assigns) do
    ~H"""

      <%= if @is_seller do %>
       <span class="inline-block px-2 text-xs text-white bg-primary-500 rounded-full text-center mb-1">
          Seller
        </span>
      <% else %>
        <span class="inline-block px-2 text-xs text-white bg-orange-500 rounded-full text-center mb-1">
          Buyer
        </span>
      <% end %>
    """
  end
end
