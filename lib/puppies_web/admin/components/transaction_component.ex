defmodule PuppiesWeb.Admin.Transactions do
  @moduledoc """
  Thread component
  """
  use PuppiesWeb, :live_component
  alias Puppies.Admin.{Transactions, Stripe}
  alias Puppies.Utilities

  def update(assigns, socket) do
    {:ok,
     assign(
       socket,
       transactions: get_transactions(assigns.customer_id),
       user_id: assigns.user_id,
       admin: assigns.admin
     )}
  end

  def handle_event("refund-transaction", %{"transaction_id" => transaction_id}, socket) do
    Stripe.refund(transaction_id, socket.assigns.admin)

    {:noreply,
     assign(
       socket,
       transactions: get_transactions(socket.assigns.customer_id)
     )}
  end

  def get_transactions(customer_id) do
    Transactions.transactions(customer_id)
  end

  def render(assigns) do
    ~H"""
    <div>
    <%= if @transactions == [] do %>
        <div class="p-4">
            <%= live_component(PuppiesWeb.Admin.Empty, id: "no-transactions", title: "No Transactions", message: "") %>
        </div>
    <% else %>
      <ul role="list" class="divide-y divide-gray-200">
        <%= for transaction <- @transactions do %>
          <li class="py-4">
            <div class="">
              <p class="text-sm font-medium text-gray-900"><%= transaction.description %></p>
              <div class="flex justify-between">
                <div>
                  <p class="text-sm text-gray-500">
                    Created: <%= Utilities.format_short_date_time(Utilities.integer_to_date(transaction.created)) %>
                    <br />
                    Merchant: <span class="capitalize"><%= transaction.merchant %></span>
                    <%= if transaction.reference_number do %>
                      <br />
                      Reference Number: <span class="capitalize"><%= transaction.reference_number %></span>
                    <% end %>
                  </p>

                <%= if transaction.refunded do %>
                  <div class="text-red-500 text-sm mt-2 p-1 border border-red-500 rounded">
                    Refunded on <%= Utilities.format_short_date_time(transaction.updated_at) %> by <%= transaction.admin.first_name %> <%= transaction.admin.last_name %>
                    Refund ID: <%= transaction.refund_id %>
                  </div>
                <% end %>
                </div>
                <%= if !transaction.refunded do %>
                  <button phx-click="refund-transaction" phx-value-transaction_id={transaction.id} phx-target={@myself} type="button" class="inline-flex items-center text-xs font-medium text-primary-500 hover:text-primary-700 underline">
                    Refund
                  </button>
                <% end %>
              </div>
            </div>
          </li>
        <% end %>
      </ul>
    <% end %>
    </div>
    """
  end
end
