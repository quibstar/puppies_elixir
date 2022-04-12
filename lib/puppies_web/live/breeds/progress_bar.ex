defmodule PuppiesWeb.ProgressBarComponent do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class="">
        <div class="text-gray-500"><%= @title %></div>
        <div class="flex justify-between text-xs text-gray-400">
          <div><%= @lower_bound %></div>
          <div><%= @upper_bound %></div>
        </div>
        <div class="bg-gray-200 h-1 w-full mt-3 ml--8 rounded">
          <div class={"bg-primary-500 h-1 rounded"} style={"width: #{100/5 *  @attribute}%"}></div>
        </div>
      </div>
    """
  end
end
