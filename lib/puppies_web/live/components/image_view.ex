defmodule PuppiesWeb.ImageViewer do
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div
      x-data="{ currentPhoto: '{@current_photo}', photoGallery: false }"
      class="mt-4 md:mt-0 md:col-span-2 md:flex relative overflow-hidden"
      >
        <div @click="getCurrentIndexAndSetPrevNext"  x-on:click="photoGallery = ! photoGallery" id="photo-view" class="mr-2 h-64 md:h-full w-full bg-cover bg-center rounded cursor-pointer"></div>
        <div id="photo-container" class="md:w-20 space-x-2 md:space-x-0 mt-2 md:mt-0 flex md:block md:space-y-2 overflow-scroll md:max-h-96 rounded">
          <%= for {photo, index} <- Enum.with_index(@photos) do %>
            <div @click={"() => showImage(#{index})"}  class='cursor-pointer rounded-sm overflow-hidden relative  md:min-h-20'>
              <%= img_tag photo, class: "object-cover", "data-url": photo, alt: "#{photo}" %>
            </div>
          <% end %>
        </div>

      <div class="fixed inset-0 overflow-hidden z-50"
        x-show="photoGallery"
        x-transition:enter="ease-in-out duration-500"
        x-transition:enter-start="opacity-0"
        x-transition:enter-end="opacity-100"
        x-transition:leave="ease-in-out duration-500"
        x-transition:leave-start="opacity-100"
        x-transition:leave-end="opacity-0"
        x-init="getCurrentIndexAndSetPrevNext()"
        >
        <div class="absolute inset-0 bg-black bg-opacity-90 transition-opacity" aria-hidden="true"
          x-show="photoGallery"
          x-transition
          ></div>

        <div class="fixed right-0 h-screen w-screen"
          x-show="photoGallery"
          x-transition
        >
            <button x-on:click="photoGallery = ! photoGallery" class="text-white absolute top-2 right-2">
              <svg class="w-8 h-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
              </svg>
            </button>

            <div class="flex items-center h-screen w-screen">

              <button class="cursor-pointer px-2 py-20" id="image-viewer-prev">
                <svg class="text-white  w-8 h-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
                </svg>
              </button>

              <div class="w-full">
                <img src={@current_photo} class="mx-auto" id="current-image">
              </div>

              <button class="cursor-pointer px-2 py-20" id="image-viewer-next">
                <svg  class="text-white w-8 h-8" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7" />
                </svg>
              </button>

            </div>
        </div>
      </div>
    </div>
    """
  end
end
