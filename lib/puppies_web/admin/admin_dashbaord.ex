defmodule PuppiesWeb.Admin.Dashboard do
  use PuppiesWeb, :live_view

  alias Puppies.Admin.Flags

  def mount(_params, _session, socket) do
    {:ok, page_data("1", "12", socket, "users")}
  end

  def page_data(page, limit, socket, dashboard_tab) do
    user_flag_count = Flags.flag_count()
    system_flag_count = Flags.flag_count(true)

    users =
      if dashboard_tab == "users" do
        Flags.open_flags(page, limit)
      else
        Flags.open_flags(page, limit, true)
      end

    flag_count =
      if dashboard_tab == "users" do
        user_flag_count
      else
        system_flag_count
      end

    assign(
      socket,
      pagination: users.pagination,
      users: users.users,
      user_flag_count: user_flag_count,
      system_flag_count: system_flag_count,
      limit: limit,
      page: page,
      dashboard_tab: dashboard_tab,
      flag_count: flag_count
    )
  end

  def handle_event("dashboard_tab", %{"dashboard_tab" => tab}, socket) do
    {:noreply, page_data("1", "12", socket, tab)}
  end

  def open_flags(flags) do
    Enum.reduce(flags, 0, fn flag, acc ->
      if flag.resolved == false do
        acc + 1
      else
        acc
      end
    end)
  end

  def render(assigns) do
    ~H"""
     <div class="py-6">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 md:px-8">
          <h1 class="text-2xl font-semibold text-gray-900">Dashboard</h1>

        <div class="flex items-center border-b border-gray-200">
          <nav class="flex-1 -mb-px flex space-x-6 xl:space-x-8" aria-label="Tabs">
            <button phx-click="dashboard_tab" phx-value-dashboard_tab="users" class={"#{if @dashboard_tab == "users", do: "border-primary-500 text-primary-600", else: ""} whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"} >
              User Flags
              <%= if @user_flag_count > 0 do %>
                (<%= @user_flag_count %>)
              <% end %>
            </button>
            <button phx-click="dashboard_tab" phx-value-dashboard_tab="system"class={"#{if @dashboard_tab == "system", do: "border-primary-500 text-primary-600", else: ""} border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"} >
              System Flags
              <%= if @system_flag_count > 0 do %>
                (<%= @system_flag_count %>)
              <% end %>
            </button>
          </nav>
        </div>
      </div>
      <div class="flex flex-col flex-1">
        <div class="flex-1 pb-8">
          <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex flex-col mt-2">
              <div class="align-middle min-w-full overflow-x-auto shadow overflow-hidden sm:rounded-lg">
                <table class="min-w-full divide-y divide-gray-200">
                  <thead>
                    <tr>
                      <th class="px-6 py-3 bg-gray-50 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Name
                      </th>
                      <th class="px-6 py-3 bg-gray-50 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Approved
                      </th>
                      <th class="px-6 py-3 bg-gray-50 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        User Status
                      </th>
                      <th class="px-6 py-3 bg-gray-50 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                        Flag Count
                      </th>
                    </tr>
                  </thead>
                  <tbody class="bg-white divide-y divide-gray-200">
                    <%= for user <- @users do %>
                        <tr>
                          <td class="px-6 py-2 whitespace-nowrap ">
                            <div class="flex items-center">
                              <%= PuppiesWeb.Avatar.show(%{business: user.business, user: user, square: "16", extra_classes: "text-4xl pt-0.5"}) %>
                              <div class="ml-4">
                                <div class="text-sm font-medium text-gray-900 underline">
                                  <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.Admin.User, user.id) do %>
                                    <%= user.first_name %> <%= user.last_name %> (<%= user.id %>)
                                  <% end %>
                                </div>
                                <div class="text-sm text-gray-500">
                                  <%= user.email %>
                                </div>
                                <div class="text-sm text-gray-500">
                                  Profile Name: <%= user.first_name %> <%= user.last_name %>
                                </div>
                                <div>
                                  <PuppiesWeb.ReputationLevel.badge reputation_level={user.reputation_level} />
                                </div>
                              </div>
                            </div>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-right">
                            <span class={"#{if user.approved_to_sell, do: "bg-green-100 text-green-800", else: "bg-red-100 text-red-800"} capitalize px-2 inline-flex text-xs leading-5 font-semibold rounded-full"}>
                               <%= user.approved_to_sell %>
                            </span>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-right">
                            <span class={"#{if user.status == "active", do: "bg-green-100 text-green-800", else: "bg-red-100 text-red-800"} capitalize px-2 inline-flex text-xs leading-5 font-semibold rounded-full"}>
                              <%= user.status %>
                            </span>
                          </td>
                          <td class="px-6 py-4 whitespace-nowrap text-sm text-right">
                            <div class="text-red-600">
                              <%= open_flags(user.flags) %>
                            </div>
                          </td>
                        </tr>
                    <% end %>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>

      <%= if @flag_count > String.to_integer(@limit) do %>
        <%= live_component PuppiesWeb.PaginationComponent, pagination: @pagination, socket: @socket, page: @page, limit: @limit %>
      <% end %>
      </div>
    </div>
    """
  end
end
