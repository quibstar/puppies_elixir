defmodule PuppiesWeb.ReviewTitleRatingCount do
  @moduledoc """
  Progress component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class="grid grid-cols-4 gap-2 text-sm">
        <div><%= @title %></div>
        <div class="col-span-2 px-1 mt-2">
          <div class="bg-gray-200 h-1 w-full  ml--8 rounded">
            <div class={"bg-primary-500 h-1 rounded"} style={"width: #{100/5 *  @rating}%"}></div>
          </div>
        </div>
        <div><%= @count %></div>
      </div>
    """
  end
end
