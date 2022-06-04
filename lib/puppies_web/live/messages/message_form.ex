defmodule PuppiesWeb.MessageForm do
  use PuppiesWeb, :live_component

  def render(assigns) do
    ~H"""
      <div class="bg-white border-t-[1px]">
        <div class="p-4">
          <%= if  @current_thread.receiver.reputation_level > @current_thread.sender.reputation_level do %>
            <div class="text-gray-500">
              <p>To communicate with <%= @current_thread.receiver.first_name %> <%= @current_thread.receiver.last_name %> you must be at the reputation level of <PuppiesWeb.Badges.reputation_level reputation_level={@current_thread.receiver.reputation_level} /></p>
              <p>You are currently at level <PuppiesWeb.Badges.reputation_level reputation_level={@current_thread.sender.reputation_level} /></p>
              <div class="mt-2">
                  <%= live_redirect "Level up!", to: Routes.live_path(@socket, PuppiesWeb.VerificationsLive), class: "inline-block px-4 py-2 border border-transparent text-xs rounded shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500" %>
              </div>
            </div>
          <% else %>
            <div class="mt-1">
              <.form let={f} for={@changeset} id="chat-form" phx-submit="save_message" phx_change="validate">
                <%= hidden_input f , :sent_by, value: @current_thread.sender.id %>
                <%= hidden_input f , :received_by, value: @current_thread.receiver.id %>
                <%= hidden_input f , :thread_uuid, value: @current_thread.uuid %>
                <%= textarea f, :message, class: "focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md" %>
                <div class="mt-4 flex justify-end">
                    <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
                </div>
              </.form>
            </div>
          <% end %>
        </div>
      </div>
    """
  end
end
