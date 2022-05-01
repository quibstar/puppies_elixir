defmodule GoldVerified do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
      <div class='max-w-7xl container mx-auto my-4'>
        <div class="md:max-w-2xl mx-auto p-8 bg-white border border-gray-200 rounded-2xl shadow-s relative">
            <div class="flex-1">
                <.live_component module={BronzeSilverGoldList} id="bronze-silver-gold-list"/>
                <p class="mt-4 flex items-baseline text-primary-500">
                    <span class="text-3xl md:text-5xl font-extrabold tracking-tight">Congratulations! <br />You are truly reputable.</span>
                </p>
                <p class="mt-6 text-gray-500">
                  You've obtained the highest reputation level allow. Enjoy all our site has to offer.
                </p>
            </div>
        </div>
      </div>
    """
  end
end
