defmodule IDVerificationLive do
  use Phoenix.LiveComponent
  alias Puppies.Stripe

  def update(assigns, socket) do
    res = Stripe.create_identity_verification_session(assigns.user.id)

    client_secret =
      case res do
        {:ok, r} ->
          Map.get(r, :client_secret)

        {:error, _} ->
          nil
      end

    {:ok, assign(socket, client_secret: client_secret)}
  end

  def render(assigns) do
    ~H"""
      <div class='max-w-5xl container mx-auto my-4'>
        <div class="md:w-1/2 mx-auto p-8 bg-white border border-gray-200 rounded-2xl shadow-s relative">
            <div class="flex-1">
                <.live_component module={BronzeSilverGoldList} id="bronze-silver-gold-list"/>
                <p class="mt-4 flex items-baseline text-primary-500">
                    <span class="text-5xl font-extrabold tracking-tight">ID Verification</span>
                </p>
                <p class="mt-4 text-gray-500">
                  You are currently still at silver until you verify your ID. Once verified you will have achieved Gold.
                  <div class="mt-4">
                    <input type="hidden" id='pub-key' value={Application.get_env(:stripity_stripe, :publishable_key)}/>
                    <input type="hidden" id="cs" value={@client_secret}/>
                    <button id="verify-button" phx-hook="verifyIdentity" class="inline-flex items-center px-4 py-2 border border-transparent text-xs rounded shadow-sm text-white bg-primary-600 hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">Gold upgrade ready!</button>
                  </div>
                </p>

                  <div class="hidden rounded-md bg-red-50 p-4 mt-4" id="error-container">
                    <div class="flex">
                      <div class="flex-shrink-0">
                        <svg class="h-5 w-5 text-red-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                          <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd" />
                        </svg>
                      </div>
                      <div class="ml-3">
                        <h3 class="text-sm font-medium text-red-800" id="error-text"></h3>
                      </div>
                    </div>
                  </div>

            </div>
        </div>
      </div>
    """
  end
end
