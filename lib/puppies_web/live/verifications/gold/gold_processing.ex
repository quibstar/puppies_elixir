defmodule GoldProcessing do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
      <div class='max-w-7xl container mx-auto my-4'>
        <div class="md:w-1/2 mx-auto p-8 bg-white border border-gray-200 rounded-2xl shadow-s relative">
            <div class="flex-1">
                <.live_component module={BronzeSilverGoldList} id="bronze-silver-gold-list"/>
                <p class="mt-4 flex items-baseline text-primary-500">
                    <span class="text-5xl font-extrabold tracking-tight">Still processing...</span>
                </p>
                <p class="mt-6 text-gray-500">
                  Processing your ID verification, please check back later.
                </p>
            </div>
        </div>
      </div>
    """
  end
end
