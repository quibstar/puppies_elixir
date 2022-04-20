defmodule PuppiesWeb.ReviewStats do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
    <div class="bg-white mt-4 border rounded">
       <div class="lg:grid grid-cols-3 p-4">
        <div class="lg:mt-4 lg:mx-auto w-24 h-24 bg-primary-500 text-white rounded-full py-6 px-2 text-center">
          <div class="text-2xl"><%= @review_stats.average %></div>
          <div class="text-sm">Out of  5</div>
        </div>
        <div class="col-span-2 space-y-1 mt-3">
          <%= live_component PuppiesWeb.ReviewTitleRatingCount, title: "5 Star", rating: 5, count: Map.get(@review_stats, :stars_5, 0) %>
          <%= live_component PuppiesWeb.ReviewTitleRatingCount, title: "4 Star", rating: 4, count: Map.get(@review_stats, :stars_4, 0) %>
          <%= live_component PuppiesWeb.ReviewTitleRatingCount, title: "3 Star", rating: 3, count: Map.get(@review_stats, :stars_3, 0) %>
          <%= live_component PuppiesWeb.ReviewTitleRatingCount, title: "2 star", rating: 2, count: Map.get(@review_stats, :stars_2, 0) %>
          <%= live_component PuppiesWeb.ReviewTitleRatingCount, title: "1 Star", rating: 1, count: Map.get(@review_stats, :stars_1, 0) %>
        </div>
       </div>
    </div>
    """
  end
end
