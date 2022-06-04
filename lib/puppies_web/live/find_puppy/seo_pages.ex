defmodule PuppiesWeb.FindPuppyLive do
  use PuppiesWeb, :live_view
  alias Puppies.{ES.ListingsSearch, Utilities, Accounts}

  @size "24"
  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(params, session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    state = Map.get(params, "state", nil)
    city = Map.get(params, "city", nil)
    breed = Map.get(params, "breed", nil)

    matches = listing_from_params(state, city, breed, "1", @size, "newest")

    count = Map.get(matches, :count, 0)

    socket =
      assign(
        socket,
        user: user,
        loading: false,
        matches: Map.get(matches, :matches, []),
        pagination: Puppies.Pagination.pagination(count, "1", @size),
        match: %{
          limit: @size,
          page: "1",
          sort: :newest
        },
        state: state,
        page_title: page_title(city, state, breed),
        city: city,
        state: state,
        breed: breed
      )

    {:ok, socket}
  end

  def handle_event("page-to", %{"page_id" => page_id}, socket) do
    match =
      socket.assigns.match
      |> Map.put(:page, page_id)
      |> Map.put(:sort, socket.assigns.match.sort)

    {:noreply,
     socket
     |> push_patch(to: url_based_on_params(socket, match))}
  end

  def handle_event("changed", %{"match" => match}, socket) do
    limit = socket.assigns.match.limit
    page = socket.assigns.match.page

    match =
      socket.assigns.match
      |> Map.put(:page, page)
      |> Map.put(:limit, limit)
      |> Map.put(:sort, match["sort"])

    {:noreply,
     socket
     |> push_patch(to: url_based_on_params(socket, match))}
  end

  def handle_params(params, _uri, socket) do
    if params["match"] do
      match = params["match"]
      page = match["page"]
      limit = match["limit"]
      sort = match["sort"]
      state = params["state"]
      city = params["city"]
      breed = params["breed"]
      matches = listing_from_params(state, city, breed, page, limit, sort)
      count = Map.get(matches, :count, 0)

      updated_match =
        if Map.has_key?(socket.assigns, "match") do
          socket.assigns.match
          |> Map.put(:page, page)
          |> Map.put(:limit, limit)
          |> Map.put(:sort, sort)
        else
          %{}
          |> Map.put(:page, page)
          |> Map.put(:limit, limit)
          |> Map.put(:sort, sort)
        end

      socket =
        assign(
          socket,
          matches: Map.get(matches, :matches, []),
          pagination: Puppies.Pagination.pagination(count, page, @size),
          match: updated_match
        )

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  defp listing_from_params(state, city, breed, page, size, filter) do
    case {state, city, breed} do
      {state, nil, nil} ->
        ListingsSearch.state(state, page, size, filter)

      {state, city, nil} ->
        ListingsSearch.city_state(city, state, page, size, filter)

      {state, city, breed} ->
        ListingsSearch.city_state_breed(city, state, breed, page, size, filter)
    end
  end

  def url_based_on_params(socket, match) do
    state = socket.assigns.state
    city = socket.assigns.city
    breed = socket.assigns.breed

    cond do
      !is_nil(city) && !is_nil(state) && !is_nil(breed) ->
        Routes.live_path(
          socket,
          PuppiesWeb.FindPuppyLive,
          city,
          state,
          breed,
          match: match
        )

      !is_nil(city) && !is_nil(state) && is_nil(breed) ->
        Routes.live_path(socket, PuppiesWeb.FindPuppyLive, city, state, match: match)

      !is_nil(city) && is_nil(state) && !is_nil(breed) ->
        Routes.live_path(socket, PuppiesWeb.FindPuppyLive, state, match: match)
    end
  end

  defp page_title(city, state, breed) do
    "Puppies in #{state} "

    case {state, city, breed} do
      {state, nil, nil} ->
        state = Utilities.state_to_human_readable(state)

        "Puppies in #{Utilities.state_to_human_readable(state)} "

      {state, city, nil} ->
        "Puppies in #{Utilities.slug_to_string(city)}, #{Utilities.state_to_human_readable(state)} "

      {state, city, breed} ->
        "#{String.capitalize(breed)} puppies in #{Utilities.slug_to_string(city)}, #{Utilities.state_to_human_readable(state)} "
    end
  end

  def render(assigns) do
    ~H"""
      <div class="h-full max-w-7xl mx-auto px-4 py-6 sm:px-6 md:justify-start md:space-x-10 lg:px-8">
          <%= if @loading == false do %>
              <div class='container mx-auto my-4 px-2 md:px-0 h-full'>
                  <%= if length(@matches) > 0 do %>
                      <div class='md:flex justify-between'>
                          <div class='flex'>
                              <div class="text-xl md:text-3xl">
                                <%= cond do %>
                                  <% !is_nil(@state) && !is_nil(@city) && !is_nil(@breed) -> %>
                                    <span class="capitalize"><%= Utilities.slug_to_string(@breed) %></span> puppies in <span class="capitalize"><%= Utilities.slug_to_string(@city) %>, <%= Utilities.state_to_human_readable(@state) %></span>.
                                  <% !is_nil(@state) && !is_nil(@city) && is_nil(@breed) -> %>
                                    Puppies in <span class="capitalize"><%= Utilities.slug_to_string(@city) %>, <%= Utilities.state_to_human_readable(@state) %></span>.
                                  <% !is_nil(@state) && is_nil(@city) && is_nil(@breed) -> %>
                                    Puppies in <span class="capitalize"><%= Utilities.state_to_human_readable(@state) %></span>.
                                <% end %>
                              </div>
                          </div>
                          <div class="my-2">
                            <%= PuppiesWeb.FilterComponent.render(%{user: nil, selected: @match.sort}) %>
                          </div>
                      </div>
                      <span class="inline-flex items-center px-2.5 py-0.5 rounded-md text-sm font-medium bg-primary-500 text-white"> <%= @pagination.count %> available! </span>
                  <% end %>
                  <%= if length(@matches) > 0 do %>
                    <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4 my-4">
                      <%= for listing <- @matches do %>
                        <%= live_component  PuppiesWeb.StateSearchCard, id: listing["_id"], listing: listing["_source"], user: @user %>
                      <% end %>
                    </div>
                    <%= if @pagination.count > String.to_integer(@match.limit) do %>
                      <%= PuppiesWeb.PaginationParamsHiddenComponent.render(%{pagination: @pagination, socket: @socket, page: @match.page, limit: @match.limit}) %>
                    <% end %>

                    <div class="bg-primary-700 rounded">
                      <div class="max-w-2xl mx-auto text-center py-16 px-4 sm:py-20 sm:px-6 lg:px-8">
                          <h2 class="text-3xl font-extrabold text-white sm:text-4xl">
                              <span class="block capitalize"><%= Utilities.state_to_human_readable(@state) %> puppies </span>
                              <span class="block">are waiting for you.</span>
                          </h2>
                          <p class="mt-4 text-lg leading-6 text-primary-200">There are <%= @pagination.count %> new friends to be made. <br />Their so excited they're peeing on the carpet!</p>
                          <%= link "Sign up for free", to: Routes.user_registration_path(@socket, :new), class: "mt-8 w-full inline-flex items-center justify-center px-5 py-3 border border-transparent text-base font-medium rounded-md text-primary-600 bg-white hover:bg-primary-50 sm:w-auto" %>
                      </div>
                    </div>
                  <% else %>
                    <div class="h-full flex justify-center items-center mx-auto">
                      <div class="text-center bg-white shadow p-4 rounded">
                          <svg xmlns="http://www.w3.org/2000/svg" class="mx-auto h-12 w-12 text-gray-400" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                              <path stroke-linecap="round" stroke-linejoin="round" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                          </svg>
                          <h3 class="mt-2 text-sm font-medium text-gray-900">So Sorry!</h3>
                          <p class="mt-1 text-sm text-gray-500">
                              No puppies available in <span class="capitalize"> <%= Utilities.state_to_human_readable(@state) %></span>. Maybe try <%= live_redirect "searching", to: Routes.live_path(@socket, PuppiesWeb.SearchLive), class: "underline py-3 md:p-0 block text-base text-gray-500 hover:text-gray-900 nav-link" %>
                          </p>
                      </div>
                  </div>
                  <% end %>
              </div>
          <% else %>
              <%= live_component PuppiesWeb.LoadingComponent, id: "matches-loading" %>
          <% end %>
      </div>
    """
  end
end
