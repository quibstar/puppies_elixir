defmodule PuppiesWeb.ListingsStatusUpdateForm do
  use PuppiesWeb, :live_view

  alias Puppies.{Accounts, Listings, Utilities, ES, ReviewLinks}

  def mount(%{"listing_id" => listing_id}, session, socket) do
    case connected?(socket) do
      true -> connected_mount(listing_id, session, socket)
      false -> {:ok, assign(socket, loading: true)}
    end
  end

  def connected_mount(listing_id, session, socket) do
    user =
      if connected?(socket) && Map.has_key?(session, "user_token") do
        %{"user_token" => user_token} = session
        Accounts.get_user_by_session_token(user_token)
      end

    listing = Listings.get_listing(listing_id)
    changeset = Listings.change_listing(listing)

    {:ok, assign(socket, user: user, loading: false, listing: listing, changeset: changeset)}
  end

  def handle_event("validate", %{"listing" => params}, socket) do
    changeset =
      Listings.change_listing(socket.assigns.listing, params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("save_listing", %{"listing" => params}, socket) do
    %{"id" => id} = params
    listing = Listings.get_listing(id)
    listing = Listings.update_listing(listing, params)

    case listing do
      {:ok, listing} ->
        ES.Listings.re_index_listing(listing.id)

        if(!is_nil(params["buyer_email"]) && listing.status == "sold") do
          ReviewLinks.create_review_link(%{
            email: params["buyer_email"],
            listing_id: listing.id
          })
        end

        {
          :noreply,
          socket
          |> put_flash(:info, "Listing updated")
          |> push_redirect(to: Routes.live_path(socket, PuppiesWeb.UserDashboardLive))
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def render(assigns) do
    ~H"""
      <div class="max-w-3xl mx-auto">
        <%= if @loading do %>
        <% else %>
          <section aria-labelledby="listing-form">
            <div class="bg-white shadow sm:rounded-lg my-4">
              <div class="px-4 py-5 sm:px-6 space-y-4">
                  <h1>

                    <%= img_tag Utilities.first_image(@listing.photos), class: "inline-block h-24 w-24 rounded-full ring-2 ring-primary-500 ring-offset-1" %>
                    <span class="inline-block ml-2">Listing status for: <%= @listing.name%></span>

                  </h1>

                  <div class="relative mt-4">
                    <div class="absolute inset-0 flex items-center" aria-hidden="true">
                      <div class="w-full border-t border-gray-300"></div>
                    </div>
                    <div class="relative flex justify-center">
                      <span class="px-2 bg-white text-sm text-gray-500">Current Status</span>
                    </div>
                  </div>

                  <.form let={f} for={@changeset} id="listing-form" phx-submit="save_listing" phx_change="validate">
                    <%= hidden_input f, :id %>
                    <div class="mt-4">
                      <%= label f, :status, class: "block text-sm font-medium text-gray-700" %>
                      <%= select f, :status, ["available", "hold", "sold"], class: "capitalize pl-3 pr-10 py-2 text-base border-gray-300 focus:outline-none focus:ring-primary-500 focus:border-primary-500 sm:text-sm rounded-md" %>
                    </div>

                    <%= if Map.has_key?(@changeset.changes, :status ) && @changeset.changes.status == "sold" do %>
                      <div class="mt-4">
                        <%= label f, "Buyer Email", class: "block text-sm font-medium text-gray-700" %>
                        <%= text_input f, :buyer_email, class: "shadow-sm focus:ring-primary-500 focus:border-primary-500  sm:text-sm border-gray-300 rounded-md" %>
                        <p class="text-gray-400 text-sm">Send buyer an email to review the transaction.</p>
                      </div>
                    <% end %>

                    <div class=" mt-4">
                      <%= submit "Submit", phx_disable_with: "Saving...",  disabled: !@changeset.valid?,  class: "inline-block px-6 py-2 text-xs font-medium leading-6 text-center text-white uppercase transition bg-primary-500 rounded shadow hover:shadow-lg hover:bg-primary-600 focus:outline-none disabled:opacity-50" %>
                    </div>
                  </.form>

                  <div class="relative mt-4">
                    <div class="absolute inset-0 flex items-center" aria-hidden="true">
                      <div class="w-full border-t border-gray-300"></div>
                    </div>
                    <div class="relative flex justify-center">
                      <span class="px-2 bg-white text-sm text-gray-500"> Status Defined </span>
                    </div>
                  </div>

                  <div class="text-gray-500 text-sm space-y-2">
                    <div>
                      <h3 class="font-semibold">Active</h3>
                      <p> Listing status that are active will show up on your breeders page and be available in city, state and breed searches.</p>
                    </div>
                    <div>
                      <h3 class="font-semibold">On Hold/Sale Pending</h3>
                      <p>Listing that are on hold will only be available on your dashboard. Listing on hold will stay on hold until you changes the listing status.</p>
                    </div>
                    <div>
                      <h3 class="font-semibold">Sold</h3>
                      <p>Listing that are sold will be marked as sold and will not be seen on the breeder page and will be unavailable in city, state or breed searches. Upon marking the listing as sold you will be given the opportunity to send the purchaser a link for a review. The purchaser <strong>does not have to be a member of our community</strong>, but they <strong>must register</strong> to complete the review process.</p>
                    </div>
                  </div>
              </div>
            </div>
          </section>
        <% end %>
      </div>
    """
  end
end
