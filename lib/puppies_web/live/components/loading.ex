defmodule PuppiesWeb.LoadingComponent do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class='container mx-auto my-4 px-2 md:px-0 h-full'>
        <div class="h-full flex justify-center items-center">
          <div class="text-center">
              <svg xmlns="http://www.w3.org/2000/svg" class="animate-spin mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
              </svg>
              <h3 class="mt-2 text-sm font-medium text-gray-900">Loading</h3>
              <p class="mt-1 text-sm text-gray-500">
                  Release the hounds!
              </p>
          </div>
        </div>
      </div>
    """
  end
end
