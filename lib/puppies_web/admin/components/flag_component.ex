defmodule PuppiesWeb.Admin.Flags do
  @moduledoc """
  Profile component
  """
  use PuppiesWeb, :live_component

  def update(assigns, socket) do
    flags = separate_flags(assigns.flags)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:open_flags, flags.open_flags)
     |> assign(:closed_flags, flags.closed_flags)
     |> assign(:open_flag_count, length(flags.open_flags))
     |> assign(:closed_flag_count, length(flags.closed_flags))}
  end

  def separate_flags(flags) do
    Enum.reduce(flags, %{open_flags: [], closed_flags: []}, fn flag, acc ->
      if flag.resolved do
        closed = [flag | acc.closed_flags]
        Map.put(acc, :closed_flags, closed)
      else
        open = [flag | acc.open_flags]
        Map.put(acc, :open_flags, open)
      end
    end)
  end

  def render(assigns) do
    ~H"""
    <div x-data="{ tab: 'flags' }" class="bg-white shadow rounded-lg p-4 mb-4">
      <div class="border-b border-gray-200">
        <nav class="-mb-px flex space-x-2" aria-label="Tabs">
          <button :class="{ 'active-tab': tab === 'flags' }" @click="tab = 'flags'" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm">
              Flags
              <%= if @open_flag_count > 0 do %>
    		        (<%= @open_flag_count %>)
    	        <% end %>
          </button>
          <button :class="{ 'active-tab': tab === 'resolved-flags' }" @click="tab = 'resolved-flags'" class="border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 whitespace-nowrap py-4 px-1 border-b-2 font-medium text-sm">
              Resolved Flags
              <%= if @closed_flag_count > 0 do %>
    		        (<%= @closed_flag_count %>)
    	        <% end %>
          </button>
        </nav>
      </div>

      <div class="bg-white p-4">
          <div x-show="tab === 'flags'">
              <%= if @open_flags == [] do %>
                <div class="p-4">
                  <%= live_component(PuppiesWeb.Admin.Empty, id: "no-flags", title: "No Flags", message: "") %>
                </div>
              <% else %>
                <div class="sm:divide-y sm:divide-gray-200">
                  <%= for flag <- @open_flags do %>
                      <div class="text-sm py-2">
                        <div class="text-gray-500 flex justify-between">
                          <%= if flag.system_reported do %>
                            <div>System Flag</div>
                          <% else %>
                            <div>
                              <div>
                                  <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.Admin.User, flag.reporter.id) do %>
                                    Reported by: <span class="underline"><%= flag.reporter.first_name %> <%= flag.reporter.last_name %> (id: <%= flag.reporter.id %>)</span>
                                  <% end %>
                              </div>
                            </div>
                          <% end %>
                          <div>
                            <button phx-click="resolve-flag" phx-value-flag_id={flag.id} class="inline bg-transparent hover:bg-primary-500 text-primary-500 text-xs hover:text-white py-1 px-2 border border-primary-500 hover:border-transparent rounded">
                                Resolve
                            </button>
                          </div>
                        </div>
                        <div class="text-red-500 my-2 bg-red-100  p-2 border border-red-400 rounded-md">
                          <%= if flag.reason == "other" do %>
                            <%= flag.custom_reason %>
                          <% else %>
                            <%= flag.reason %>
                          <% end %>
                        </div>
                      </div>
                  <% end %>
                </div>
              <% end %>
          </div>
          <div x-show="tab === 'resolved-flags'">
          <%= if @closed_flags == [] do %>
                <div class="p-4">
                  <%= live_component(PuppiesWeb.Admin.Empty, id: "no-resolved-flags", title: "No Resolved Flags", message: "") %>
                </div>
              <% else %>
                <div class="bg-white divide-y divide-gray-500">
                  <%= for flag <- @closed_flags do %>
                    <div class="text-sm py-2">
                      <div class="text-gray-500">
                        <%= if flag.system_reported do %>
                          <div>System Flag</div>
                        <% else %>
                          <div class="text-red-500 my-2 bg-red-100  p-2 border border-red-400 rounded-md">
                            <%= if flag.reason == "other" do %>
                              <%= flag.custom_reason %>
                            <% else %>
                              <%= flag.reason %>
                            <% end %>
                          </div>
                        <% end %>
                      </div>
                      <div class="flex">
                          <div class="text-xs text-gray-500">Resolved by: <%= flag.admin.first_name %> <%= flag.admin.last_name %> <%= Puppies.Utilities.format_short_date_time(flag.updated_at) %></div>
                      </div>
                    </div>
                  <% end %>
                </div>
              <% end %>
          </div>
      </div>
    </div>
    """
  end
end
