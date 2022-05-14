defmodule PuppiesWeb.Admin.DrawerComponent do
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class={"z-10 fixed inset-0 overflow-hidden ease-in-out transition #{if @resource_id == nil, do: "w-0", else: "w-full"}"} aria-labelledby="slide-over-title" role="dialog" aria-modal="true">
        <div class="absolute inset-0 overflow-hidden">
          <div class={"absolute inset-0 bg-gray-500 bg-opacity-75 transition-opacity ease-in-out duration-700 #{if @resource_id == nil, do: "opacity-0", else: "opacity-100"}"} aria-hidden="true"></div>
          <div class={"fixed inset-y-0 right-0 pl-10 max-w-full flex transform transition ease-in-out duration-500 sm:duration-700 #{if @resource_id == nil, do: "translate-x-full", else: "translate-x-0"}"}>
            <div class={"w-screen max-w-md transform transition ease-in-out duration-500 sm:duration-700 #{if @resource_id == nil, do: "translate-x-full", else: "translate-x-0"}"}>
              <div class="h-full flex flex-col py-6 bg-white shadow-xl overflow-y-scroll">
                <div class="px-4 sm:px-6">
                  <div class="flex items-start justify-between">
                    <h2 class="text-lg font-medium text-gray-900" id="slide-over-title">
                      <%= @drawer_title %>
                    </h2>
                    <div class="ml-3 h-7 flex items-center">
                      <button phx-click="hide-drawer" type="button" class="bg-white rounded-md text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-primary-2 focus:ring-primary-500">
                        <span class="sr-only">Close panel</span>
                        <!-- Heroicon name: outline/x -->
                        <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                      </button>
                    </div>
                  </div>
                </div>
                <div class="mt-6 relative flex-1 px-4 sm:px-6">
                  <%= if is_nil(@resource_id) do %>
                    Loading
                  <% else %>
                    <%= live_component @component, id: @resource_id %>
                  <% end %>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    """
  end
end
