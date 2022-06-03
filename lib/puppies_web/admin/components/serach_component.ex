defmodule Puppies.SearchComponent do
  use PuppiesWeb, :live_component
  alias Puppies.Admin.SearchSchema

  def update(_assigns, socket) do
    changeset = SearchSchema.changeset(%SearchSchema{}, %{})
    {:ok, assign(socket, changeset: changeset, results: [])}
  end

  def handle_event("changed", %{"search_schema" => %{"term" => term}}, socket) do
    changeset = SearchSchema.changeset(%SearchSchema{}, %{term: term})

    search =
      if String.length(term) > 2 do
        Puppies.ES.AdminSearch.query(term)
      else
        %{users: [], count: 0}
      end

    {:noreply,
     assign(socket,
       changeset: changeset,
       users: search.users,
       count: search.count,
       term: term
     )}
  end

  def render(assigns) do
    ~H"""
    <div >
      <div class="relative z-10" role="dialog" aria-modal="true"
        x-show="show_search"
        x-transition:enter="ease-out duration-300"
        x-transition:enter-start="opacity-0"
        x-transition:enter-end="opacity-100"
        x-transition:leave="ease-in duration-200"
        x-transition:leave-start="opacity-100"
        x-transition:leave-end="opacity-0"
      >
        <div class="fixed inset-0 bg-gray-500 bg-opacity-25 transition-opacity"></div>

        <div class="fixed inset-0 z-10 overflow-y-auto p-4 sm:p-6 md:p-20"
          x-show="show_search"
          x-transition:enter="ease-out duration-300"
          x-transition:enter-start="opacity-0 scale-95"
          x-transition:enter-end="opacity-100 scale-100"
          x-transition:leave="ease-in duration-200"
          x-transition:leave-start="opacity-100 scale-100"
          x-transition:leave-end="opacity-0 scale-95"
        >
          <div class="mx-auto max-w-xl transform divide-y divide-gray-100 overflow-hidden rounded-xl bg-white shadow-2xl ring-1 ring-black ring-opacity-5 transition-all">
            <div class="relative">
              <!-- Heroicon name: solid/search -->
               <.form let={f} for={@changeset} id="admin-search-form" phx_change="changed" phx-target={@myself}>
                <div class="flex">
                  <svg class="pointer-events-none absolute top-3.5 left-4 h-5 w-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                    <path fill-rule="evenodd" d="M8 4a4 4 0 100 8 4 4 0 000-8zM2 8a6 6 0 1110.89 3.476l4.817 4.817a1 1 0 01-1.414 1.414l-4.816-4.816A6 6 0 012 8z" clip-rule="evenodd" />
                  </svg>
                   <%= text_input f, :term, class: "h-12 w-full border-0 bg-transparent pl-11 pr-4 text-gray-800 placeholder-gray-400 focus:ring-0 sm:text-sm", autocomplete: "off", placeholder: "Search",  x_ref: "input"  %>

                  <button type='button' x-on:click="show_search = !show_search" class="text-gray-800 p-1 m-2 text-xs border rounded-lg">
                  ESC
                  </button>
                </div>
              </.form>
            </div>

           <%= if Map.has_key?(assigns, :users) && @users != [] do %>
              <ul class="max-h-full scroll-py-2 overflow-y-auto py-2 text-sm text-gray-800" id="options" role="listbox">
                <%= for user <- @users  do %>
                  <li class="cursor-default select-none px-4 py-2" role="option" tabindex="-1" x-on:click="show_search = !show_search">
                    <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.Admin.User, user.id) do %>
                      <div class="font-semibold"><%= user.name %></div>
                      <%= for {k, v}  <- user.highlight do %>
                        <div class="text-gray-500 text-xs"><span class="text-gray-800"><%= Phoenix.Naming.humanize(k) %></span>: <%= raw List.first(v) %></div>
                      <% end %>
                    <% end %>
                  </li>
                <% end %>
              </ul>
            <% end %>
            <%= if Map.has_key?(assigns, :term) do %>
              <%= if String.length(@term) > 2 && @users == [] do %>
                <p class="p-4 text-sm text-gray-500">No people found.</p>
              <% end %>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
