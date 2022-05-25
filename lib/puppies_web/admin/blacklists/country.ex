defmodule PuppiesWeb.Admin.CountryBlacklist do
  use PuppiesWeb, :live_component

  alias Puppies.{Blacklists}

  def update(assigns, socket) do
    selected_countries = Blacklists.get_selected_blacklisted_countries()
    countries = Blacklists.get_country_blacklist()

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:countries, countries)
     |> assign(:selected_countries, selected_countries)}
  end

  def handle_event("add-country", %{"country" => id}, socket) do
    country = Blacklists.get_country(id)
    Blacklists.update_blacklisted_country(country, %{selected: true})
    selected_countries = Blacklists.get_selected_blacklisted_countries()

    {:noreply,
     assign(
       socket,
       selected_countries: selected_countries
     )}
  end

  def handle_event("remove-country", %{"country_id" => id}, socket) do
    country = Blacklists.get_country(id)
    Blacklists.update_blacklisted_country(country, %{selected: false})
    selected_countries = Blacklists.get_selected_blacklisted_countries()

    {:noreply,
     assign(
       socket,
       selected_countries: selected_countries
     )}
  end

  def render(assigns) do
    ~H"""
    <div>
        <div class="md:flex gap-4">
          <.form let={_} for={:country_blacklist} phx-target={@myself} phx-change="add-country" >
            <fieldset class="space-y-5">
              <select name="country" class="mt-1 pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm rounded-md">
                <%= for country <- @countries do %>
                  <option value={country.id}><%= country.name %> </option>
                <% end %>
              </select>
            </fieldset>
          </.form>
          <p class="text-sm text-gray-600 w-80">
            When a user signs up/in there IP will be checked. If the IP region is associated with any country chosen they will be automatically suspended.
          </p>
        </div>
        <div class="my-4">
          <%= for selected <- @selected_countries do %>
            <span class="inline-flex rounded-full items-center py-0.5 pl-2.5 pr-1 text-sm font-medium bg-primary-100 text-primary-700">
              <%= selected.name %>
              <button type="button" phx-target={@myself} phx-click="remove-country" phx-value-country_id={selected.id} class="flex-shrink-0 ml-0.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-400 hover:bg-primary-200 hover:text-primary-500 focus:outline-none focus:bg-primary-500 focus:text-white">
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
