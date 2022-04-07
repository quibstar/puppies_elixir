defmodule PuppiesWeb.SearchLive do
  use PuppiesWeb, :live_view
  alias Puppies.{Accounts, Dogs, Utilities}

  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, socket |> assign(:loading, true) |> assign(:search, %{})}
    end
  end

  def connected_mount(params, session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

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

    can_submit =
      if(!is_nil(params["state"]) || !is_nil(params["state"])) do
        true
      else
        false
      end

    socket =
      assign(
        socket,
        %{
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
          selected_breeds: [],
          selected_state: nil,
          breeds_options: breeds_options,
          can_submit: can_submit,
          distance: "15",
          search_by: "state"
        }
      )

    {:ok, socket}
  end

  def handle_event("changed", %{"_target" => target, "search" => search}, socket) do
    cond do
      target == ["search", "place_name"] ->
        %{"place_name" => place_name} = search

        q =
          if String.length(place_name) > 3 do
            MapBox.mapbox_place(place_name)
          else
            []
          end

        {:noreply,
         assign(
           socket,
           results: q,
           params: search
         )}

      true ->
        # search for breeds
        search = Map.put(search, "breeds", socket.assigns.params["breeds"])
        # check for state
        selected_state =
          if target == ["search", "state"] do
            search["state"]
          else
            nil
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

        socket =
          assign(
            socket,
            breed_queried: breed_queried,
            params: search,
            selected_state: selected_state,
            search_by: search["search_by"]
          )

        update_url(socket, search)
    end
  end

  def handle_event("choose-city", %{"place_id" => place_id}, socket) do
    place = get_place_from_results(socket, place_id)

    params =
      socket.assigns.params
      |> Map.put("place_id", place.place_id)
      |> Map.put("lat", place.lat)
      |> Map.put("lng", place.lng)
      |> Map.put("place_name", place.place_name)

    socket =
      socket
      |> assign(results: [])
      |> assign(params: params)

    {:noreply, socket}
  end

  def handle_event("page-to", %{"page_id" => page_id}, socket) do
    params = socket.assigns.params |> Map.put("page", page_id)
    update_url(socket, params)
  end

  def handle_event("search", %{"search" => search}, socket) do
    # clean up by removing params
    search = Map.delete(search, "breed")
    update_url(socket, search)
  end

  def handle_event("choose-breed", %{"id" => id}, socket) do
    dog = Dogs.get_breed!(id)
    selected_breeds = socket.assigns.selected_breeds ++ [dog]

    breed_urls =
      Enum.reduce(selected_breeds, [], fn breed, acc ->
        [breed.slug | acc]
      end)

    params = Map.put(socket.assigns.params, breed_urls, [])

    socket =
      assign(
        socket,
        selected_breeds: selected_breeds,
        breed_queried: [],
        params: params
      )

    {:noreply, socket}
  end

  def handle_event("remove-breed", %{"id" => id}, socket) do
    selected_breeds =
      Enum.reduce(socket.assigns.selected_breeds, [], fn breed, acc ->
        if("#{breed.id}" != id) do
          acc ++ [breed]
        else
          acc
        end
      end)

    socket =
      assign(
        socket,
        selected_breeds: selected_breeds
      )

    {:noreply, socket}
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

  def handle_params(params, _uri, socket) do
    if params["search"] && socket.assigns.loading == false do
      params = params["search"]
      query_search_params(socket, params)
    else
      {:noreply, socket}
    end
  end

  def query_search_params(socket, params) do
    page = check_param(params["page"], "1")
    limit = check_param(params["limit"], "60")

    param_breeds = Map.get(params, "breeds", [])
    assigns_breeds = Map.get(socket.assigns, :breeds, [])

    selected_breeds =
      Enum.reduce(assigns_breeds, [], fn breed, acc ->
        if Enum.member?(param_breeds, breed.slug) do
          [breed | acc]
        else
          acc
        end
      end)

    socket =
      assign(
        socket,
        results: [],
        params: params,
        selected_breeds: selected_breeds
      )

    {:noreply, socket}
  end

  def check_for_param(search, param) do
    if Map.has_key?(search, param) do
      Map.get(search, param)
    else
      []
    end
  end

  def check_param(param, return_value) do
    cond do
      param == nil ->
        return_value

      Regex.match?(~r{\A\d*\z}, param) == true ->
        param

      true ->
        return_value
    end
  end

  def update_url(socket, search) do
    {:noreply,
     socket
     |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.SearchLive, search: search))}
  end

  def values_for_breeds_multi_select(selected_breeds) do
    res =
      Enum.reduce(selected_breeds, [], fn breed, acc ->
        [breed.slug | acc]
      end)

    res
  end

  # location helper
  def get_place_from_results(socket, place_id) do
    Enum.find(socket.assigns.results, fn x ->
      x.place_id == place_id
    end)
  end

  def render(assigns) do
    ~H"""
    <%= if @loading == false do %>
      <div class=" max-w-7xl mx-auto px-4 py-6 sm:px-6 lg:px-8">
        <form id="search-form"  phx-submit="search" phx-change="changed" class="w-full">
          <%= hidden_input :search, :is_filtering,  value: Map.get(@params, "is_filtering", false)  %>
          <div class="md:flex my-4 border bg-white rounded p-4">

              <div class="mr-2 ">
                  <%= label :search, :search_by, class: "block"%>
                  <%= select :search, :search_by, [ {"State", "state"}, {"Location", "location"}], selected: @params["search_by"], class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>
              </div>

              <div class="mr-2 flex-grow relative">
                <%= label :search, :breed, class: "block"%>
                <%= text_input :search, :breed, autocomplete: "off", class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>

                <%= multiple_select :search, :breeds, @breeds_options, value: values_for_breeds_multi_select(@selected_breeds), class: "hidden"%>

                <%= if @breed_queried != [] do %>
                  <ul class="absolute z-10 mt-1 max-h-60 w-full overflow-auto rounded-md bg-white py-1 text-base shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none sm:text-sm" id="options" role="listbox">
                    <%= for breed <- @breed_queried do %>
                      <li phx-click="choose-breed" phx-value-id={breed.id} class="cursor-pointer relative py-2 pl-3 pr-9 text-gray-900 hover:text-white hover:bg-primary-500"  role="option">
                          <%= breed.name %>
                      </li>
                    <% end %>
                  </ul>
                <% end %>
              </div>

              <%= if @search_by == "state" do %>
                <div class="mr-2 flex-grow">
                  <%= label :search, :state, class: "block"%>
                  <%= select :search, :state, @states, selected: @params["state"], class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>
                </div>
              <% end %>

              <%= if @search_by == "location" do %>
                <div class="flex-grow mr-2">
                    <%= label :search, :location, class: "block" %>
                    <%= hidden_input :search, :is_filtering,  value: Map.get(@params, "is_filtering", false)  %>
                    <%= hidden_input :search, :place_id,  value: @params["place_id"] %>
                    <%= hidden_input :search, :lat,  value: @params["lat"] %>
                    <%= hidden_input :search, :lng,  value: @params["lng"] %>
                    <%= text_input :search, :place_name, class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md",  autocomplete: "off", placeholder: "Enter city", value: @params["place_name"] %>
                    <%= if length( @results) > 0 do %>
                        <div id="results" class="shadow absolute z-50 max-h-64 overflow-scroll bg-white">
                        <%= for place <- @results do %>
                            <div class="text-sm p-2 border-b cursor-pointer hover:bg-primary-500 hover:text-white text-gray-500" phx-click="choose-city" phx-value-place_id={place.place_id}>
                                <%= place.place_name %>
                            </div>
                        <% end %>
                        </div>
                        <div class=" text-gray-500 text-right">Found: <%= length(@results)%></div>
                    <% end %>
                </div>


                <div class="mr-2">
                    <%= label :search, :distance, class: "block"%>
                    <%= select :search, :distance, [ {"15 Miles", 15}, {"20 Miles", 20}, {"25 Miles", 25}, {"50 Miles", 50},{"100 Miles", 100}, {"250 Miles", 250},{"500 Miles", 500}, {"Any distance", 0}], class: "shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md", selected: @params["distance"] %>
                </div>
              <% end %>

              <div class="mr-2 ">
                  <%= label :search, :order, class: "block"%>
                  <%= select :search, :order, [ {"Newest", :newest}, {"Price low to high", :price_low_to_high}, {"Price high to low", :price_high_to_low}, {"Reputation Level", :reputation_level}], selected: @params["order"], class: "w-full shadow-sm focus:ring-primary-500 focus:border-primary-500 sm:text-sm border-gray-300 rounded-md" %>
              </div>

              <div class="mt-6 flex ">
                  <div>
                      <%= submit "Search", phx_disable_with: "Searching...", class: "mr-2 inline-flex justify-center py-1.5 px-4 border border-transparent shadow rounded text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50", disabled: false %>
                  </div>
                <button type="button" class="inline-flex justify-center py-1.5 px-4 border border-transparent shadow rounded text-primary-700 bg-primary-200 hover:text-white hover:bg-primary-400 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 disabled:opacity-50" phx-click="toggle-filter">
                    <svg class="w-5 h-5 inline-block" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6V4m0 2a2 2 0 100 4m0-4a2 2 0 110 4m-6 8a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4m6 6v10m6-2a2 2 0 100-4m0 4a2 2 0 110-4m0 4v2m0-6V4" />
                    </svg>
                    Filter
                </button>
              </div>
          </div>
        </form>

      <!-- filter -->
      <div  class={"#{if @params["is_filtering"] == "true", do: " ", else: "idden" }"}>

        <.live_component module={FilterComponent} id="filter" params={@params} />
      </div>
      <!-- pills -->
      <div class="my-4">
        <%= for breed <- @selected_breeds do %>
          <span class="inline-flex rounded-full items-center py-1 pl-3 pr-1 text-sm font-medium bg-primary-100 text-primary-700 ">
            <%= breed.name %>
            <button type="button" class="flex-shrink-0 ml-0.5 h-4 w-4 rounded-full inline-flex items-center justify-center text-primary-400 hover:bg-primary-200 hover:text-primary-500 focus:outline-none focus:bg-primary-500 focus:text-white" phx-click="remove-breed" phx-value-id={breed.id} >
              <span class="sr-only">Remove large option</span>
              <svg class="h-2 w-2" stroke="currentColor" fill="none" viewBox="0 0 8 8">
                <path stroke-linecap="round" stroke-width="1.5" d="M1 1l6 6m0-6L1 7" />
              </svg>
            </button>
          </span>
        <% end %>
      </div>

      </div>
         <% else %>
        <%= live_component PuppiesWeb.LoadingComponent, id: "search-loading" %>
      <% end %>

    """
  end
end
