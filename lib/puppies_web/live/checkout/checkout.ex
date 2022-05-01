defmodule PuppiesWeb.CheckoutLive do
  @moduledoc """
  Matches live view index
  """
  use PuppiesWeb, :live_view

  alias Puppies.{Accounts, Products, Stripe}

  def mount(params, session, socket) do
    case connected?(socket) do
      true -> connected_mount(params, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(%{"product" => product}, session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    product = Products.get_product_by_name(product)

    intent =
      if product.name == "ID Verification" do
        Stripe.payment_intent(product, user)
      else
        Stripe.create_subscription(user, product.price_id)
      end

    {:ok,
     socket
     |> assign(:loading, false)
     |> assign(:user, user)
     |> assign(:product, product)
     |> assign(:intent_client_secret, intent.client_secret)}
  end

  def render(assigns) do
    ~L"""
    <%= if @loading == false do %>
      <div class='max-w-5xl container mx-auto my-4'>
          <div class="md:w-1/2 mx-auto p-8 bg-white border border-gray-200 rounded-2xl shadow-s relative">
              <%= cond do %>
                  <% @product.name == "Standard" -> %>
                      <%= PuppiesWeb.ProductComponent.standard(@socket) %>
                  <% @product.name == "Premium" -> %>
                      <%= PuppiesWeb.ProductComponent.premium(@socket) %>
                    <% @product.name == "ID Verification" -> %>
                      <%= PuppiesWeb.ProductComponent.id_verification(@socket) %>
              <% end %>
          <div class="p-4 mt-4" phx-update="ignore">
              <input type="hidden" id='pub-key' value="<%= Application.get_env(:stripity_stripe, :publishable_key)%>"/>
              <form id="payment-form" data-secret="<%= @intent_client_secret %>">
                  <div id="payment-element"></div>
                  <button id="submit" class="w-full text-center bg-primary-500 text-white rounded p-2 mt-4 disabled:opacity-50">
                      <span class="spinner hidden" id="spinner">
                          <svg xmlns="http://www.w3.org/2000/svg" class="animate-spin mx-auto h-8 w-8" fill="none" viewBox="0 0 24 24" stroke="white">
                              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                          </svg>
                      </span>
                      <span id="button-text">Submit Payment</span>
                  </button>
                  <div id="payment-message" class="my-2 p-2 rounded text-red-500"></div>
              </form>
          </div>
          <div id="ds"  data-secret="<%= @intent_client_secret %>"></div>
      </div>

    <% else %>
      <%= live_component PuppiesWeb.LoadingComponent,  id: :loading %>
    <% end %>
    """
  end
end
