defmodule PuppiesWeb.FilterComponent do
  @moduledoc """
  Reusable radio
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~L"""
      <form phx-change="changed">
          <div class="flex flex-wrap justify">
              <%= if @user != nil do %>
                  <%= hidden_input :match, :id,  value: @user.id %>
              <% end %>
              <div class="mr-2">
                  <%= select :match, :sort, [ {"Newest", :newest}, {"Reputation Level", :reputation_level},  {"Price low to high", :price_low_to_high}, {"Price high to low", :price_high_to_low} ,{"Most Views", :most_views}, {"Least Views", :least_views} ], class: "mt-1 block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm rounded-md", selected: @selected %>
              </div>
          </div>
      </form>
    """
  end
end
