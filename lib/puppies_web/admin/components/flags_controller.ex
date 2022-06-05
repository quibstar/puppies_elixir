defmodule PuppiesWeb.Admin.FlagsController do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class="flex justify-between mb-2">
        <div class="flex space-x-2 text-sm items-center text-primary-500 hover:text-primary-700">
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M11 17l-5-5m0 0l5-5m-5 5h12" />
          </svg>
          Previous <%= @title %> flag
        </div>
        <div class="flex space-x-2 text-sm items-center text-primary-500 hover:text-primary-700">
          Next  <%= @title %> flag
          <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
            <path stroke-linecap="round" stroke-linejoin="round" d="M13 7l5 5m0 0l-5 5m5-5H6" />
          </svg>
        </div>
      </div>
    """
  end
end
