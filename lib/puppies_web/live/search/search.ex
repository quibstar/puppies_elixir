defmodule PuppiesWeb.SearchLive do
  use PuppiesWeb, :live_view
  alias Puppies.{Accounts, Dogs, Utilities, Searches, Search}

  @size "60"

  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, socket |> assign(:loading, true)}
    end
  end

  def connected_mount(_params, session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    changeset = Searches.change_search(%Search{})

    states =
      Utilities.states()
      |> Enum.reduce([], fn state, acc ->
        acc ++ ["#{state.name}": state.abbreviation]
      end)

    breeds = Dogs.list_breeds()

    breeds_options =
      Enum.reduce(breeds, [], fn breed, acc ->
        acc ++ ["#{breed.name}": breed.slug]
      end)

    socket =
      assign(
        socket,
        %{
          changeset: changeset,
          states: states,
          breeds: breeds,
          show_filter: false,
          results: [],
          user: user,
          action: nil,
          loading: false,
          params: %{"is_filtering" => "false", "breeds" => [], "state" => ""},
          page_title: "Find you next best friend - ",
          breed_queried: [],
          selected_state: nil,
          breeds_options: breeds_options,
          search_by: "state",
          matches: [],
          pagination: Puppies.Pagination.pagination(0, "1", @size),
          limit: @size,
          page: "1",
          sort: :newest
        }
      )

    {:ok, socket}
  end

  def handle_event("changed", %{"_target" => target, "search" => search}, socket) do
    locations =
      if target == ["search", "place_name"] do
        %{"place_name" => place_name} = search

        if String.length(place_name) > 3 do
          MapBox.mapbox_place(place_name)
        else
          []
        end
      end

    breed_queried =
      if target == ["search", "breed"] && String.length(search["breed"]) > 2 do
        Enum.reduce(socket.assigns.breeds, [], fn breed, acc ->
          breed_downcase = String.downcase(breed.name)
          search_downcase = String.downcase(search["breed"])

          if String.starts_with?(breed_downcase, search_downcase) do
            [breed | acc]
          else
            acc
          end
        end)
      else
        []
      end

    changeset =
      Searches.change_search(%Search{}, search)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket,
       changeset: changeset,
       breed_queried: breed_queried,
       search_by: search["search_by"],
       results: locations
     )}
  end

  def handle_event("choose-city", %{"place_id" => place_id}, socket) do
    place = get_place_from_results(socket, place_id)

    params =
      socket.assigns.params
      |> Map.put("place_id", place.place_id)
      |> Map.put("lat", place.lat)
      |> Map.put("lng", place.lng)
      |> Map.put("place_name", place.place_name)

    changeset =
      Searches.change_search(%Search{}, params)
      |> Map.put(:action, :validate)

    socket =
      socket
      |> assign(results: [])
      |> assign(params: params)

    {:noreply,
     assign(socket,
       changeset: changeset,
       results: []
     )}
  end

  def handle_event("page-to", %{"page_id" => page_id}, socket) do
    params = socket.assigns.params |> Map.put("page", page_id)
    update_url(socket, params)
  end

  def handle_event("search", %{"search" => search}, socket) do
    update_url(socket, search)
  end

  def handle_event("choose-breed", %{"breed_slug" => breed_slug}, socket) do
    current = Map.get(socket.assigns.params, "breeds", [])
    breeds = [breed_slug | current]
    params = Map.put(socket.assigns.params, "breeds", breeds)
    changeset = Searches.change_search(%Search{}, params)

    socket =
      assign(
        socket,
        breed: "",
        changeset: changeset,
        breed_queried: []
      )

    socket = assign(socket, params: params)

    if changeset.valid? do
      update_url(socket, params)
    else
      {:noreply, socket}
    end
  end

  def handle_event("remove-breed", %{"breed" => breed}, socket) do
    breeds =
      Enum.reduce(socket.assigns.params["breeds"], [], fn b, acc ->
        if b != breed do
          [b | acc]
        else
          acc
        end
      end)

    params = Map.put(socket.assigns.params, "breeds", breeds)
    changeset = Searches.change_search(%Search{}, params)

    socket =
      assign(
        socket,
        changeset: changeset
      )

    socket = assign(socket, params: params)
    update_url(socket, params)
  end

  def handle_event("toggle-filter", _, socket) do
    is_filtering =
      case socket.assigns.params["is_filtering"] do
        "true" ->
          "false"

        "false" ->
          "true"
      end

    params =
      socket.assigns.params
      |> Map.put("is_filtering", is_filtering)

    socket = assign(socket, params: params)
    {:noreply, socket}
  end

  def handle_event("remove_filter", %{"key" => key}, socket) do
    params = Map.delete(socket.assigns.params, key)
    socket = assign(socket, params: params)
    update_url(socket, params)
  end

  def handle_params(params, _uri, socket) do
    if params["search"] && socket.assigns.loading == false do
      params = params["search"]
      changeset = Searches.change_search(%Search{}, params)

      matches = Puppies.ES.ListingsSearch.query_builder(params)

      count = Map.get(matches, :count, 0)
      page = Map.get(params, "page", 0)

      socket =
        assign(
          socket,
          changeset: changeset,
          results: [],
          params: params,
          search_by: params["search_by"],
          matches: Map.get(matches, :matches, []),
          pagination: Puppies.Pagination.pagination(count, page, @size)
        )

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def check_for_param(search, param) do
    if Map.has_key?(search, param) do
      Map.get(search, param)
    else
      []
    end
  end

  def update_url(socket, search) do
    {:noreply,
     socket
     |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.SearchLive, search: search))}
  end

  # location helper
  def get_place_from_results(socket, place_id) do
    Enum.find(socket.assigns.results, fn x ->
      x.place_id == place_id
    end)
  end

  def format_breed(breed) do
    humanize(breed) |> String.capitalize()
  end

  def render(assigns) do
    ~H"""
    <%= if @loading do %>
      <%= live_component PuppiesWeb.LoadingComponent, id: "search-loading" %>
    <% else %>
      <div class=" max-w-7xl mx-auto px-4 py-6 sm:px-6 lg:px-8">
        <.form let={f} for={@changeset} id="search-form" phx-submit="search" phx_change="changed">
          <%= hidden_input f, :is_filtering %>
          <%= hidden_input f, :page, value: Map.get(@params,"page", "1")%>
          <%= hidden_input f, :limit, value:  Map.get(@params, "limit", "60") %>
          <%= multiple_select f, :breeds, @breeds_options, class: "hidden"%>

          <div class="md:flex my-4 border bg-white rounded p-4">

              <div class="mr-2 ">
                  <%= label f, :search_by, class: "block"%>
                  <%= select f, :search_by, [ {"State", "state"}, {"Location", "location"}], class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>
              </div>

              <div class="mr-2 flex-grow relative">
                <%= label f, :breed, class: "block"%>
                <%= text_input f, :breed, autocomplete: "off", class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>

                <%= if @breed_queried != [] do %>
                  <ul class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm" id="options" role="listbox">
                    <%= for breed <- @breed_queried do %>
                      <li phx-click="choose-breed" phx-value-breed_slug={breed.slug} class="cursor-pointer relative py-2 pl-3 pr-9 text-gray-900 hover:text-white hover:bg-primary-500"  role="option">
                          <%= breed.name %>
                      </li>
                    <% end %>
                  </ul>
                <% end %>
              </div>

              <%= if @search_by == "state" do %>
                <div class="mr-2 flex-grow">
                  <%= label f, :state, class: "block"%>
                  <%= select f, :state, @states, prompt: "Select a state", class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>
                </div>
              <% end %>

              <%= if @search_by == "location" do %>
                <div class="flex-grow mr-2">
                    <%= label f, :location, class: "block" %>
                    <%= hidden_input f, :is_filtering,  value: Map.get(@params, "is_filtering", false)  %>
                    <%= hidden_input f, :place_id,  value: @params["place_id"] %>
                    <%= hidden_input f, :lat,  value: @params["lat"] %>
                    <%= hidden_input f, :lng,  value: @params["lng"] %>
                    <%= text_input f, :place_name, class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md",  autocomplete: "off", placeholder: "Enter city", value: @params["place_name"] %>
                    <%= if !is_nil( @results) do %>
                      <div id="results" class="shadow absolute z-50 max-h-64 overflow-scroll bg-white">
                        <%= for place <- @results do %>
                            <div class="text-sm p-2 border-b cursor-pointer hover:bg-primary-500 hover:text-white text-gray-500" phx-click="choose-city" phx-value-place_id={place.place_id}>
                                <%= place.place_name %>
                            </div>
                        <% end %>
                      </div>
                    <% end %>
                </div>


                <div class="mr-2">
                    <%= label f, :distance, class: "block"%>
                    <%= select f, :distance, [ {"15 Miles", 15}, {"20 Miles", 20}, {"25 Miles", 25}, {"50 Miles", 50},{"100 Miles", 100}, {"250 Miles", 250},{"500 Miles", 500}, {"Any distance", 0}], class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md", selected: @params["distance"] %>
                </div>
              <% end %>

              <div class="mr-2 ">
                  <%= label f, :order, class: "block"%>
                  <%= select f, :order, [ {"Newest", :newest}, {"Price low to high", :price_low_to_high}, {"Price high to low", :price_high_to_low}, {"Reputation Level", :reputation_level}], selected: @params["order"], class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>
              </div>

              <div class="mt-6 flex ">
                  <div>
                      <%= submit "Search", phx_disable_with: "Searching...", class: "mr-2 inline-flex justify-center py-1.5 px-4 border border-transparent shadow rounded text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50", disabled: !@changeset.valid? %>
                  </div>
                <button type="button" class="inline-flex justify-center py-1.5 px-4 border border-transparent shadow rounded text-primary-700 bg-primary-200 hover:text-white hover:bg-primary-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50" phx-click="toggle-filter">
                    <svg class="w-5 h-5 inline-block" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
                    </svg>
                    Filter
                </button>
              </div>
          </div>
            <!-- filter -->
            <div  class={"#{if @params["is_filtering"] == "true", do: " ", else: "hidden" }"}>
              <.live_component module={FilterComponent} id="filter" params={@params} f={f} />
            </div>
        </.form>


        <!-- pills -->
        <%= for key <- [:champion_sired, :show_quality, :champion_bloodline, :registered, :registrable, :pedigree, :current_vaccinations, :veterinary_exam, :health_certificate, :health_guarantee, :hypoallergenic, :microchip] do %>
          <%= live_component PuppiesWeb.SearchPill, key: key, is_filtering: @params[Atom.to_string(key)], label: key %>
        <% end %>

        <%= live_component PuppiesWeb.SearchPill, key: :sex, is_filtering: @params["sex"] == "male", label: :male %>
        <%= live_component PuppiesWeb.SearchPill, key: :sex, is_filtering: @params["sex"] == "female", label: :female %>

        <%= live_component PuppiesWeb.SearchPill, key: :bloodline, is_filtering: @params["bloodline"] == "purebred", label: :purebred %>
        <%= live_component PuppiesWeb.SearchPill, key: :bloodline, is_filtering: @params["bloodline"] == "designer", label: :designer %>
        <%= live_component PuppiesWeb.SearchPill, key: :bloodline, is_filtering: @params["bloodline"] == "purebred_and_designer", label: :purebred_and_designer %>

        <%= live_component PuppiesWeb.SearchPill, key: :dob, is_filtering: !is_nil(@params["dob"]) && @params["dob"] != "-1", label: :age %>
        <%= live_component PuppiesWeb.SearchPill, key: :min_price, is_filtering: !is_nil(@params["min_price"]) && @params["min_price"] != "-1" , label: :min_price %>
        <%= live_component PuppiesWeb.SearchPill, key: :max_price, is_filtering: !is_nil(@params["max_price"]) && @params["max_price"] != "-1", label: :min_price %>

        <%= for breed <- Map.get(@params, "breeds", []) do %>
          <span class="inline-flex rounded-full items-center py-1 pl-3 pr-1 text-sm font-medium bg-primary-100 text-primary-700 ">
            <%= format_breed(breed) %>
            <button type="button" class="flex-shrink-0 ml-0.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-400 hover:bg-primary-200 hover:text-primary-500 focus:outline-none focus:bg-primary-500 focus:text-white" phx-click="remove-breed" phx-value-breed={breed} >
              <span class="sr-only">Remove large option</span>
              <svg class="h-2 w-2" stroke="currentColor" fill="none" viewBox="0 0 8 8">
                <path stroke-linecap="round" stroke-width="1.5" d="M1 1l6 6m0-6L1 7" />
              </svg>
            </button>
          </span>
        <% end %>
        <%= if length(@matches) > 0 do %>
          <div class="mt-4">
            Matches <span class="inline-flex items-center px-3 py-0.5 rounded-full text-sm font-medium bg-primary-400 text-primary-800"> <%= @pagination.count %> </span>
          </div>
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4 my-4">
            <%= for listing <- @matches do %>
                <%= live_component  PuppiesWeb.StateSearchCard, id: listing["_id"], listing: listing["_source"], user: @user %>
            <% end %>
          </div>
          <%= if @pagination.count > String.to_integer(@params["limit"]) do %>
            <%= PuppiesWeb.PaginationComponent.render(%{pagination: @pagination, socket: @socket, page: @params["page"], limit: @params["limit"]}) %>
          <% end %>
        <% end %>
      </div>
    <% end %>
    """
  end
end
