defmodule PuppiesWeb.SilverComponent do
  @moduledoc """
  Live view form for spaces
  """
  use PuppiesWeb, :live_component

  alias Puppies.{
    Accounts,
    Verifications.Twilio,
    Verifications.Phone
  }

  alias PuppiesWeb.Router.Helpers, as: Routes

  def update(assigns, socket) do
    {:ok,
     assign(socket,
       submit_code: false,
       user: assigns.user,
       show_modal: false
     )}
  end

  def handle_event("submit-phone-number", params, socket) do
    case Accounts.save_phone_number(socket.assigns.user, params) do
      {:ok, user} ->
        Twilio.post_phone_number(user.phone_intl_format)

        {:noreply,
         socket
         |> assign(user: user)
         |> assign(submit_code: true)
         |> put_flash(:info, "Verification sent to your phone")}

      {:error, _} ->
        {:noreply,
         socket
         |> assign(submit_code: false)
         |> put_flash(:info, "Error please try again")}
    end
  end

  def handle_event("submit-code", %{"confirmation_code" => confirmation_code}, socket) do
    res =
      Twilio.verify_phone_number(
        socket.assigns.user.phone_intl_format,
        confirmation_code
      )

    case res do
      {:ok, response, sid} ->
        update_account(socket.assigns.user, sid)

        {:noreply,
         socket
         |> put_flash(:info, response)
         |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.UserDashboardLive))}

      {:failure, response} ->
        {:noreply,
         socket
         |> assign(submit_code: false)
         |> put_flash(:error, response)}

      {:error, _response} ->
        {:noreply,
         socket
         # resets to retry phone again
         |> assign(submit_code: false)
         |> put_flash(:error, "Something went wrong, please try atain")}
    end
  end

  defp update_account(user, sid) do
    Accounts.update_reputation_level(user, %{reputation_level: 2})
    Phone.insert_verification(%{user_id: user.id, sid: sid})

    Puppies.BackgroundJobCoordinator.re_index_user(user.id)
  end

  def render(assigns) do
    ~H"""
    <div x-data="{ open: false }">
      <button x-on:click="open = ! open" class="inline-flex items-center px-4 py-2 border border-transparent text-xs rounded shadow-sm text-white bg-primary-500 hover:bg-primary-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">Silver upgrade ready!</button>
        <div x-show="open" phx-hook="silver_modal"  id="silver-modal" class="fixed z-10 inset-0 overflow-y-auto {if @show_modal, do: show-modal, else: hide-modal}" aria-labelledby="modal-title" role="dialog" aria-modal="true">
          <div class="flex items-end justify-center min-h-screen pt-4 px-4 pb-20 text-center sm:block sm:p-0 show-overlay">

            <div
              x-show="open"
              x-transition:enter="ease-out duration-300"
              x-transition:enter-start="opacity-0"
              x-transition:enter-end="opacity-100"
              x-transition:leave="ease-in duration-200"
              x-transition:leave-start="opacity-100"
              x-transition:leave-end="opacity-0"
              class="fixed inset-0 bg-gray-500 bg-opacity-75 transition-opacity" aria-hidden="true"></div>

            <!-- This element is to trick the browser into centering the modal contents. -->
            <span class="hidden sm:inline-block sm:align-middle sm:h-screen" aria-hidden="true">&#8203;</span>

            <div
              x-show="open"
              x-transition:enter="ease-out duration-300"
              x-transition:enter-start="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
              x-transition:enter-end="opacity-100 translate-y-0 sm:scale-100"
              x-transition:leave="ease-in duration-200"
              x-transition:leave-start="opacity-100 translate-y-0 sm:scale-100"
              x-transition:leave-end="opacity-0 translate-y-4 sm:translate-y-0 sm:scale-95"
              class="inline-block align-bottom bg-white rounded-lg text-left  shadow-xl transform transition-all sm:my-8 sm:align-middle sm:max-w-lg sm:w-full">

              <div class="hidden sm:block absolute top-0 right-0 pt-4 pr-4">
                <button x-on:click="open = !open" type="button" class="bg-white rounded-md text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500">
                  <span class="sr-only">Close</span>
                  <!-- Heroicon name: outline/x -->
                  <svg class="h-6 w-6" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor" aria-hidden="true">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
                  </svg>
                </button>
              </div>

              <div class="bg-white px-4 pt-5 pb-4 sm:p-6 sm:pb-4 rounded">
                <div class="sm:flex sm:items-start">
                  <div class="mx-auto flex-shrink-0 flex items-center justify-center h-12 w-12 rounded-full bg-primary-100 sm:mx-0 sm:h-10 sm:w-10">
                    <!-- Heroicon name: outline/exclamation -->
                    <svg class="h-6 w-6 text-primary-600" xmlns="http://www.w3.org/2000/svg" class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                    </svg>
                  </div>
                  <div>
                    <div class="mt-3 text-center sm:mt-0 sm:ml-4 sm:text-left">
                      <h3 class="text-lg leading-6 font-medium text-gray-900" id="modal-title">
                        Silver Status
                      </h3>
                      <div class="mt-2">
                        <p class="text-sm text-gray-500">
                          By verifying you phone number you will obtain silver status.
                        </p>
                      </div>
                      <%= unless @submit_code do %>
                        <form phx-submit="submit-phone-number" phx-target={@myself}>
                          <div class="my-2">
                            <input id="phone_intl_format" type="hidden" name="phone_intl_format" />
                            <label class="block text-sm font-medium text-gray-700">Phone Number</label>
                            <input id="phone" type="text" name="phone_number" onkeyup="validatePhoneNumber(event)" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"/>
                            <input type="submit" id="submit-phone-number" value="Verify" class="mt-4 inline-flex justify-center w-full rounded-md border border-transparent shadow-sm px-4 py-2 bg-primary-600 text-base font-medium text-white hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 sm:text-sm hidden"
                            />
                          </div>
                        </form>
                      <% else %>
                        <form phx-submit="submit-code" phx-target={@myself}>
                          <div class="my-2">
                            <label class="block text-sm font-medium text-gray-700">Confirmation Code</label>
                            <input id="confirmation-code" type="text" name="confirmation_code" class="shadow-sm focus:ring-primary-500 focus:border-primary-500 block w-full sm:text-sm border-gray-300 rounded-md"/>
                            <input type="submit" id="submit-phone-number" value="Confirm"
                            class="mt-4 inline-flex justify-center w-full rounded-md border border-transparent shadow-sm px-4 py-2 bg-primary-600 text-base font-medium text-white hover:bg-primary-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary-500 sm:text-sm"
                            />
                          </div>
                        </form>
                      <% end %>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
    </div>
    """
  end
end
