defmodule PuppiesWeb.CheckoutSuccessLive do
  @moduledoc """
  Matches live view index
  """
  use PuppiesWeb, :live_view

  alias Puppies.{Accounts, Stripe}

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

    payment_intent = Stripe.get_payment_intent(params["payment_intent"])
    product = payment_intent.metadata["product"]

    {:ok,
     socket
     |> assign(:loading, false)
     |> assign(:product, product)
     |> assign(:user, user)}
  end

  def render(assigns) do
    ~L"""
      <%= if @loading == false && !is_nil(@user)do %>
        <div class='max-w-5xl container mx-auto my-4'>
          <div class="md:w-1/2 mx-auto p-8 bg-white border border-gray-200 rounded-2xl shadow-s relative">
              <div class="flex-1">
                  <p class="mt-4 flex items-baseline text-primary-500">
                      <span class="text-5xl font-extrabold tracking-tight">Succuss</span>
                      <div class="ml-1 text-xl font-semibold"></div>
                  </p>
                  <p class="my-4 text-gray-500">
                    Thank you for you purchase! We processing your order right now.
                  </p>
                  <%= if @product == "ID Verification" do %>
                    <div class="rounded-md bg-blue-50 p-4">
                      <div class="flex">
                        <div class="ml-3 flex-1 md:flex md:justify-between">
                          <p class="text-sm text-blue-700">You current Have a credit for ID Verification.</p>
                          <p class="mt-3 text-sm md:mt-0 md:ml-6">
                            <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.VerificationsLive), class: "whitespace-nowrap font-medium text-blue-700 hover:text-blue-600"  do %>
                              Redeem <span aria-hidden="true">&rarr;</span>
                            <% end %>
                          </p>
                        </div>
                      </div>
                    </div>
                  <% end %>
              </div>
          </div>
        </div>
      <% else %>
        <%= live_component PuppiesWeb.LoadingComponent,  id: :loading %>
      <% end %>
    """
  end
end
