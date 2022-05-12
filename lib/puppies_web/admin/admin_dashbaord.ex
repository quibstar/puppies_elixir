defmodule PuppiesWeb.Admin.Dashboard do
  use PuppiesWeb, :live_view

  def render(assigns) do
    ~H"""
      <div class="py-6">
          <div class="max-w-7xl mx-auto px-4 sm:px-6 md:px-8">
            <h1 class="text-2xl font-semibold text-gray-900">Dashboard</h1>

          <div class="flex items-center border-b border-gray-200">
            <nav class="flex-1 -mb-px flex space-x-6 xl:space-x-8" aria-label="Tabs">

            </nav>
          </div>
        </div>
        <div class="flex flex-col flex-1">

        </div>
      </div>
    """
  end
end
