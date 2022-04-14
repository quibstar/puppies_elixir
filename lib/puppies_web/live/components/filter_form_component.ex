defmodule PuppiesWeb.FilterFormComponent do
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div>
        <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-4 gap-4 my-4 p-4 bg-white rounded shadow">
          <div>
            <%= label @f, :size, class: "text-sm block"%>
            <div class="flex justify-between text-xs text-gray-400">
              <div>Extra small</div>
              <div>Extra large</div>
            </div>
            <div class="relative mt-5">
              <%= range_input @f, :size_min, max: 5, min: 1, class: "absolute left-0 bottom-0 bg-transparent w-full h-2 appearance-none rounded" %>
              <%= range_input @f, :size_max, max: 5, min: 1, class: "absolute left-0 bottom-0 bg-primary-300 w-full h-2 appearance-none rounded" %>
              <div class="absolute left-0 bottom-0 bg-primary-400  h-2 rounded" style={"left: #{@left}%; width: #{@width}%;"}></div>
            </div>
          </div>

          <div>
            <%= label @f, :kid_friendly, class: "text-sm block"%>
            <div class="flex justify-between text-xs text-gray-400">
              <div>No</div>
              <div>Yes</div>
            </div>
            <%= range_input @f, :kid_friendly, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
          </div>

          <div>
            <%= label @f, :dog_friendly, class: "text-sm block"%>
            <div class="flex justify-between text-xs text-gray-400">
              <div>No</div>
              <div>Yes</div>
            </div>
            <%= range_input @f, :dog_friendly, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
          </div>

          <div>
            <%= label @f, :intensity, class: "text-sm block"%>
            <div class="flex justify-between text-xs text-gray-400">
              <div>Lazy</div>
              <div>Active</div>
            </div>
            <%= range_input @f, :intensity, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
          </div>

          <div>
            <%= label @f, :amount_of_shedding, class: "text-sm block"%>
            <div class="flex justify-between text-xs text-gray-400">
              <div>Little</div>
              <div>Much</div>
            </div>
            <%= range_input @f, :amount_of_shedding, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
          </div>


          <div>
            <%= label @f, :trainable, class: "text-sm block"%>
            <div class="flex justify-between text-xs text-gray-400">
              <div>No</div>
              <div>Yes</div>
            </div>
            <%= range_input @f, :trainability, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
          </div>

          <div>
            <%= label @f, :intelligence, class: "text-sm block"%>
            <div class="flex justify-between text-xs text-gray-400">
              <div>Not so smart</div>
              <div>Very smart</div>
            </div>
            <%= range_input @f, :intelligence, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
          </div>

            <div>
            <%= label @f, "Barking/Howling", class: "text-sm block"%>
            <div class="flex justify-between text-xs text-gray-400">
              <div>Never barks</div>
              <div>Vocal</div>
            </div>
            <%= range_input @f, :tendency_to_bark_or_howl, max: 5, min: 1, class: "w-full h-2 bg-primary-300 appearance-none rounded" %>
          </div>
        </div>
      </div>
    """
  end
end
