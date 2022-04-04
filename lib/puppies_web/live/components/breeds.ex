defmodule PuppiesWeb.BreedsAutoSelectComponent do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_component

  alias Puppies.{Dogs}

  def update(assigns, socket) do
    breeds = Dogs.list_breeds()

    breeds_options =
      Enum.reduce(breeds, [], fn breed, acc ->
        acc ++ ["#{breed.name}": breed.slug]
      end)

    breed_queried =
      if String.length(assigns.breed) > 2 do
        Enum.reduce(breeds, [], fn breed, acc ->
          breed_downcase = String.downcase(breed.name)
          params_downcase = String.downcase(assigns.breed)

          if String.starts_with?(breed_downcase, params_downcase) do
            [breed | acc]
          else
            acc
          end
        end)
      else
        []
      end

    {:ok,
     assign(socket,
       form: assigns.form,
       breeds: breeds,
       breeds_options: breeds_options,
       breed: assigns.breed,
       breed_queried: breed_queried,
       selected_breeds: assigns.selected_breeds,
       target: assigns.target
     )}
  end

  def render(assigns) do
    ~H"""
    <div class="mt-4">
      <div class="relative">
        <%= label @form, :breeds, class: "block text-sm font-medium text-gray-700"%>
        <%= text_input @form, :breed, autocomplete: "off", value: @breed, class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>

        <%= if @breed_queried != [] do %>
          <ul class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm" id="options" role="listbox">
            <%= for breed <- @breed_queried do %>
              <li phx-click="choose-breed" phx-value-id={breed.id} phx-target={@target} class="cursor-pointer relative py-2 pl-3 pr-9 text-gray-900 hover:text-white hover:bg-primary-500"  role="option">
                  <%= breed.name %>
              </li>
            <% end %>
          </ul>
        <% end %>
      </div>
      <div class="my-2">
        <%= for breed <- @selected_breeds do %>
          <span class="inline-flex rounded-full items-center py-1 pl-3 pr-1 mb-2 text-sm font-medium bg-primary-100 text-primary-700 ">
            <%= breed.name %>
            <button type="button" phx-click="remove-breed" phx-value-id={breed.id} phx-target={@target} class="flex-shrink-0 ml-0.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-400 hover:bg-primary-200 hover:text-primary-500 focus:outline-none focus:bg-primary-500 focus:text-white">
              <span class="sr-only">Remove large option</span>
              <svg class="h-2 w-2" stroke="currentColor" fill="none" viewBox="0 0 8 8">
                <path stroke-linecap="round" stroke-width="1.5" d="M1 1l6 6m0-6L1 7" />
              </svg>
            </button>
          </span>
        <% end %>
      </div>
    </div>
    """
  end
end
