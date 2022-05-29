defmodule PuppiesWeb.Admin.BlackLists do
  use PuppiesWeb, :live_view

  alias Puppies.Admins

  def mount(_params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(session, socket) do
    admin =
      if connected?(socket) && Map.has_key?(session, "admin_token") do
        %{"admin_token" => admin_token} = session
        Admins.get_admin_by_session_token(admin_token)
      end

    {:ok,
     assign(
       socket,
       admin: admin,
       loading: false,
       current_tab: "content",
       limit: "12",
       page: "1"
     )}
  end

  def handle_params(params, _uri, socket) do
    current_tab =
      if params["tab"] do
        params["tab"]
      else
        "content"
      end

    limit =
      if params["limit"] do
        params["limit"]
      else
        "12"
      end

    page =
      if params["page"] do
        params["page"]
      else
        "1"
      end

    {:noreply, assign(socket, current_tab: current_tab, limit: limit, page: page)}
  end

  def active_tab(tab, current_tab) do
    if tab == current_tab do
      "active-tab"
    else
      ""
    end
  end

  def render(assigns) do
    ~H"""
      <%= unless @loading do %>
        <div class="py-6" x-data={"{ tab: '#{@current_tab}' }"}>
          <div class="max-w-7xl mx-auto px-4 sm:px-6 md:px-8">
            <h1 class="text-2xl font-semibold text-gray-900">Blacklists</h1>
            <div>
              <div class="sm:block">
                <div class="border-b border-gray-200">
                  <nav class="-mb-px flex space-x-8" aria-label="Tabs">
                    <%= live_patch "Content", to: Routes.live_path(@socket, PuppiesWeb.Admin.BlackLists, tab: "content"), class: "#{active_tab("content", @current_tab)} border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" %>
                    <%= live_patch "Domain", to: Routes.live_path(@socket, PuppiesWeb.Admin.BlackLists, tab: "domain"), class: "#{active_tab("domain", @current_tab)} border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" %>
                    <%= live_patch "Phone", to: Routes.live_path(@socket, PuppiesWeb.Admin.BlackLists, tab: "phone"), class: "#{active_tab("phone", @current_tab)} border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" %>
                    <%= live_patch "IP Address", to: Routes.live_path(@socket, PuppiesWeb.Admin.BlackLists, tab: "ip-address"), class: "#{active_tab("ip-address", @current_tab)} border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" %>
                    <%= live_patch "Country", to: Routes.live_path(@socket, PuppiesWeb.Admin.BlackLists, tab: "country"), class: "#{active_tab("country", @current_tab)} border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" %>
                  </nav>
                </div>
              </div>
              <div class="py-4">
                <%= case @current_tab do %>
                  <% "content" -> %>
                    <.live_component module={PuppiesWeb.Admin.BlackListContent} id="blacklist_content" admin={@admin} limit={@limit} page={@page}/>
                  <% "domain" -> %>
                    <.live_component module={PuppiesWeb.Admin.BlackListDomain} id="blacklist_domain" admin={@admin} limit={@limit} page={@page}/>
                  <% "phone" -> %>
                    <.live_component module={PuppiesWeb.Admin.BlackListPhone} id="blacklist_phone" admin={@admin} limit={@limit} page={@page}/>
                  <% "ip-address" -> %>
                    <.live_component module={PuppiesWeb.Admin.BlackListIpAddress} id="blacklist_ip_address" admin={@admin} limit={@limit} page={@page}/>
                  <% "country" -> %>
                    <.live_component module={PuppiesWeb.Admin.CountryBlacklist} id="blacklist_country" admin={@admin} />
                <% end %>
              </div>
            </div>
          </div>
        </div>
      <% end %>
    """
  end
end
