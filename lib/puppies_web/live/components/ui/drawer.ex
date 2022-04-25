defmodule PuppiesWeb.UI.Drawer do
  use Phoenix.Component

  def drawer(assigns) do
    ~H"""
      <div>
        <div
          x-show="show_drawer"
          class="fixed inset-0 z-50 overflow-hidden" aria-labelledby="slide-over-title" role="dialog" aria-modal="true">

          <div class="absolute inset-0 overflow-hidden">
            <div
            x-show="show_drawer"
            x-transition:enter="ease-in-out duration-500"
            x-transition:enter-start="opacity-0"
            x-transition:enter-end="opacity-100"
            x-transition:leave="ease-in-out duration-500"
            x-transition:leave-start="opacity-100"
            x-transition:leave-end="opacity-0"
            class="absolute inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>

            <div class="fixed inset-y-0 right-0 pl-10 max-w-full flex">
              <div x-show="show_drawer"
                  x-transition:enter="transform transition ease-in-out duration-500 sm:duration-700"
                  x-transition:enter-start="translate-x-full"
                  x-transition:enter-end="translate-x-0"
                  x-transition:leave="transform transition ease-in-out duration-500 sm:duration-700"
                  x-transition:leave-start="translate-x-0"
                  x-transition:leave-end="translate-x-full"
                  class="relative w-screen max-w-md">

                  <div
                  x-show="show_drawer"
                  x-transition:enter="ease-in-out duration-300"
                  x-transition:enter-start="opacity-0"
                  x-transition:enter-end="opacity-100"
                  x-transition:leave="ease-in-out duration-300"
                  x-transition:leave-start="opacity-100"
                  x-transition:leave-end="opacity-0"
                  class="absolute top-0 left-0 -ml-8 pt-4 pr-2 flex sm:-ml-10 sm:pr-4">
                  <button x-on:click="show_drawer = !show_drawer" type="button" class="rounded-md text-gray-300 hover:text-white focus:outline-none focus:ring-2 focus:ring-white">
                    <span class="sr-only">Close panel</span>
                    <!-- Heroicon name: outline/x -->
                    <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                    </svg>
                  </button>
                </div>

                <div class="h-full flex flex-col py-6 bg-white shadow-xl overflow-y-scroll">
                  <div class="px-4 sm:px-6">
                    <h2 class="text-lg font-medium text-gray-900" id="slide-over-title">
                      <%= render_slot(@drawer_title) %>
                    </h2>
                  </div>
                  <div class="mt-6 relative flex-1 px-4 sm:px-6">
                      <%= render_slot(@drawer_body) %>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
    </div>
    """
  end
end
