defmodule PuppiesWeb.Admin.Empty do
  @moduledoc """
  empty data component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
    <div>
      <div class="text-center">
        <svg class="mx-auto h-12 w-12 text-gray-400" xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path vector-effect="non-scaling-stroke" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z" />
        </svg>
        <h3 class="mt-2 text-sm font-medium text-gray-900">
          <%= @title %>
        </h3>
        <p class="mt-1 text-sm text-gray-500">
          <%= @message %>
        </p>
      </div>
    </div>
    """
  end
end
