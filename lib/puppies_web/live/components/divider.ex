defmodule Divider do
  use Phoenix.Component

  # Optionally also bring the HTML helpers
  # use Phoenix.HTML

  def divider(assigns) do
    ~H"""
      <div class="relative mt-4">
        <div class="absolute inset-0 flex items-center" aria-hidden="true">
          <div class="w-full border-t border-gray-300"></div>
        </div>
        <div class="relative flex justify-center">
          <span class="px-2 bg-white text-sm text-gray-500"> <%= assigns.title %> </span>
        </div>
      </div>
    """
  end
end
