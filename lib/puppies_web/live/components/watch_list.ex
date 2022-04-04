defmodule PuppiesWeb.WatchListComponent do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <section aria-labelledby="applicant-information-title">
        <div class="bg-white shadow sm:rounded-lg">
          <div class="px-4 py-5 sm:px-6">
            <div class="flex justify-between">
              <h2 id="applicant-information-title" class="text-lg leading-6 font-medium text-gray-900">Watch List</h2>
            </div>
            <p class="mt-1 max-w-2xl text-gray-500">Add profiles to you watch list that you might want to purchase or have interest in.</p>
          </div>
        </div>
      </section>
    """
  end
end
