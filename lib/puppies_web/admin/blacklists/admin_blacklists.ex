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

    {:ok, assign(socket, admin: admin, loading: false, current_tab: "content")}
  end

  def handle_params(_params, uri, socket) do
    hash = String.split(uri, "#")

    current_tab =
      if length(hash) == 2 do
        List.last(hash)
      else
        "content"
      end

    {:noreply, assign(socket, current_tab: current_tab)}
  end

  def render(assigns) do
    ~H"""
      <%= unless @loading do %>
        <div class="py-6" x-data={"{ tab: '#{@current_tab}' }"}>
          <div class="max-w-7xl mx-auto px-4 sm:px-6 md:px-8">
            <h1 class="text-2xl font-semibold text-gray-900">Blacklists</h1>
            <div>
              <div class="sm:hidden">
                <label for="tabs" class="sr-only">Select a tab</label>
                <select id="tabs" name="tabs" class="block w-full pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm rounded-md">
                  <option>Content</option>

                  <option>Domain</option>

                  <option selected>Phone</option>

                  <option>IP address</option>
                </select>
              </div>
              <div class="hidden sm:block">
                <div class="border-b border-gray-200">
                  <nav class="-mb-px flex space-x-8" aria-label="Tabs">
                    <a href="#content" :class="{ 'active-tab': tab === 'content' }"   x-on:click="tab = 'content'" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"> Content </a>
                    <a href="#domain" :class="{ 'active-tab': tab === 'domain' }"  x-on:click="tab = 'domain'" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"> Domain </a>
                    <a href="#phone" :class="{ 'active-tab': tab === 'phone' }"  x-on:click="tab = 'phone'" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm" aria-current="page"> Phone </a>
                    <a href="#ip-address" :class="{ 'active-tab': tab === 'ip-address' }"   x-on:click="tab = 'ip-address'" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"> IP Address </a>
                    <a href="#upload-file" :class="{ 'active-tab': tab === 'upload-file' }"   x-on:click="tab = 'upload-file'" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm"> Upload File </a>
                  </nav>
                </div>
              </div>
              <div class="py-4">
                <div x-show="tab === 'content'">
                  <.live_component module={PuppiesWeb.Admin.BlackListContent} id="blacklist_content" admin={@admin} />
                </div>
                <div  x-show="tab === 'domain'">
                    <.live_component module={PuppiesWeb.Admin.BlackListDomain} id="blacklist_domain" admin={@admin} />
                </div>
                <div  x-show="tab === 'phone'">
                    <.live_component module={PuppiesWeb.Admin.BlackListPhone} id="blacklist_phone" admin={@admin} />
                </div>
                <div  x-show="tab === 'ip-address'">
                    <.live_component module={PuppiesWeb.Admin.BlackListIpAddress} id="blacklist_ip_address" admin={@admin} />
                </div>
                <div  x-show="tab === 'upload-file'">
                    <.live_component module={PuppiesWeb.Admin.UploadBlackListFile} id="upload_blacklist_file"/>
                </div>
              </div>
            </div>
          </div>

        </div>
      <% end %>
    """
  end
end
