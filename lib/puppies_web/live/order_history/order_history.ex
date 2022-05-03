defmodule PuppiesWeb.OrderHistoryLive do
  @moduledoc """
  Plans live view index
  """
  use PuppiesWeb, :live_view

  alias Puppies.{Accounts, Stripe, Transactions}

  def mount(_params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    # updates orders if any were missed
    Task.async(fn ->
      Stripe.get_subscriptions(user.customer_id)
      Stripe.get_invoices(user.customer_id)
      Stripe.get_charges(user.customer_id)
    end)

    orders = Transactions.get_user_transactions(user.customer_id)

    socket =
      assign(
        socket,
        orders: orders,
        loading: false
      )

    {:ok, socket}
  end

  def int_to_date(date) do
    {:ok, date} = DateTime.from_unix(date)
    date
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-7xl mx-auto py-24 px-4  sm:px-6 lg:px-8">
        <h2 class="text-3xl font-extrabold text-gray-900 sm:text-5xl sm:leading-none sm:tracking-tight lg:text-6xl">Order History</h2>
        <%= unless @loading do %>
          <table class="mt-4 w-full text-gray-500 sm:mt-6">
            <thead class="text-sm text-gray-500 text-left">
                <tr>
                    <th scope="col" class="">Description</th>
                    <th scope="col" class="">Status</th>
                    <th scope="col" class="text-right">Finalized</th>
                </tr>
            </thead>
            <tbody class="border-b border-gray-200 divide-y divide-gray-200 text-sm sm:border-t">
                <%= for order <- @orders do %>
                    <tr>
                        <td class="py-6">
                            <div>
                              <%= order.description %>
                              <span class="text-gray-400">
                                <%= order.reference_number  %>
                              </span>
                            </div>
                        </td>
                        <td class="capitalize">
                          <%= order.status %>
                        </td>
                        <td class="sm:table-cell text-right"><span class="messages-date" data-time={Puppies.Utilities.integer_to_date order.created}></span></td>
                    </tr>
                <% end %>
            </tbody>
          </table>
        <% end %>
      </div>
    """
  end
end
