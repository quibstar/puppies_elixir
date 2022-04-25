defmodule PuppiesWeb.MessagesLive do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_view

  alias Puppies.{Threads, Accounts, Listings, Messages}

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

    threads = Threads.get_user_threads(user.id)

    listing_threads =
      if is_nil(params["uuid"]) do
        nil
      else
        Threads.get_threads_by_user_and_listing(user.id, params["listing_id"])
      end

    current_thread = Threads.get_first_listing_thread_and_messages(user.id)
    changeset = Messages.message_changes(%{})
    socket = assign(socket, :messages, current_thread.messages)

    {:ok,
     assign(socket,
       loading: false,
       user: user,
       threads: threads,
       listing_threads: listing_threads,
       current_thread: current_thread,
       changeset: changeset,
       temporary_assigns: [messages: []]
     )}
  end

  @spec subscribe :: any
  def subscribe() do
    PubSub.subscribe(Puppies.PubSub, "liveview_chat")
  end

  def handle_params(params, _uri, socket) do
    if Map.has_key?(params, "listing_id") && socket.assigns.loading == false do
      %{"listing_id" => listing_id} = params

      listing_threads =
        Threads.get_threads_by_user_and_listing(socket.assigns.user.id, listing_id)

      listing = Listings.get_listing!(listing_id)

      current_thread =
        if is_nil(params["thread"]) do
          List.first(listing_threads)
        else
          Threads.current_thread(socket.assigns.user.id, params["thread"])
        end

      socket = assign(socket, :messages, current_thread.messages)

      socket =
        assign(
          socket,
          listing_threads: listing_threads,
          listing: listing,
          current_thread: current_thread,
          temporary_assigns: [messages: []]
        )

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  def business_or_user_name(receiver) do
    if Map.has_key?(receiver, :business) do
      receiver.business.name
    else
      receiver.name
    end
  end

  def add_class(sent_by, user_id) do
    if sent_by == user_id do
      "flex-row-reverse"
    else
      ""
    end
  end

  def current_thread_class(current_thread_id, thread_id) do
    if current_thread_id == thread_id do
      "border-primary-500"
    else
      ""
    end
  end

  def handle_event("validate", %{"message" => params}, socket) do
    changeset =
      Messages.message_changes(params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket,
       changeset: changeset
     )}
  end

  def handle_event("save_message", %{"message" => params}, socket) do
    message = Messages.create_message(params)

    case message do
      {:ok, message} ->
        changeset = Messages.message_changes(%{})

        socket =
          socket
          |> update(:messages, fn messages -> [message | messages] end)

        {:noreply,
         assign(socket,
           changeset: changeset
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def render(assigns) do
    ~H"""
      <div class='flex h-full'>
        <%= if @loading do %>
          <%= live_component PuppiesWeb.LoadingComponent, id: "listing-loading" %>
        <% else  %>
          <div class="flex-none w-[300px]  border-r-[1px] bg-white">
            <%= if is_nil(@listing_threads) do %>
              <ul>
                <li>
                  <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.MessagesLive, listing_id: @current_thread.listing_id), class: "p-4 flex rounded-lg hover:shadow-md border hover:border-primary-500 m-2 space-x-4" do %>
                    <%= PuppiesWeb.PuppyAvatar.show(%{listing: @current_thread.listing, square: 10, extra_classes: "text8_5xl"}) %>
                    <div class="ml-3 flex-grow">
                      <p class="text-sm text-gray-900">
                        <%= @current_thread.listing.name %>
                      </p>
                      <div class="text-xs text-gray-400">
                        <%= @current_thread.listing.updated_at %>
                      </div>
                    </div>
                  <% end %>
                </li>
                <%= for thread <- @threads do %>
                  <%= if thread.id != @current_thread.id do %>
                    <li>
                      <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.MessagesLive, listing_id: thread.listing_id), class: "p-4 flex rounded-lg hover:shadow-md border hover:border-primary-500 m-2 space-x-4" do %>
                        <%= PuppiesWeb.PuppyAvatar.show(%{listing: thread.listing, square: 10, extra_classes: "text8_5xl"}) %>
                        <div class="ml-3 flex-grow">
                          <p class="text-sm text-gray-900">
                            <%= thread.listing.name %>
                          </p>
                          <div class="text-xs text-gray-400">
                            <%= thread.listing.updated_at %>
                          </div>
                        </div>
                      <% end %>
                    </li>
                  <% end %>
                <% end %>
              </ul>
            <% else %>
              <div>
                <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.MessagesLive), class: "block flex items-center" do %>
                  <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 m-2 stroke-primary-500" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
                  </svg>
                  <div class="text-sm text-primary-500 flex space-x-2 p-2 items-center">
                    <%= PuppiesWeb.PuppyAvatar.show(%{listing: @current_thread.listing, square: 10, extra_classes: "text8_5xl"}) %> <div><%= @current_thread.listing.name %></div>
                  </div>
                <% end %>

                <ul >
                  <%= for thread <- @listing_threads do %>
                    <li>
                      <%= live_redirect to: Routes.live_path(@socket, PuppiesWeb.MessagesLive, listing_id: thread.listing_id, thread: thread.uuid), class: "p-4 flex rounded-lg hover:shadow-md border hover:border-primary-500 m-2 space-x-4 #{current_thread_class(@current_thread.id, thread.id)}" do %>
                        <%= PuppiesWeb.Avatar.show(%{business: thread.receiver.business, user: thread.receiver, square: 10, extra_classes: "text-2xl"}) %>
                        <div class="flex-grow">
                          <p class="text-sm text-gray-900">
                            <%= business_or_user_name(thread.receiver) %>
                          </p>
                          <p class="text-xs  text-gray-500">
                            <%= @current_thread.id == thread.id %>
                          </p>
                        </div>
                        <div class="text-xs text-gray-400 mt-1">
                          04/10/2022
                        </div>
                      <% end %>
                    </li>
                  <% end %>
                </ul>
              </div>
            <% end %>
          </div>

          <div class="grow">
            <div class="relative h-[calc(100vh-100px)]">
              <ul class="p-4 space-y-4  h-[calc(100vh-295px)] overflow-scroll" id="chat-messages" phx-update="append">
                <%= if  @messages != [] do %>
                  <%= for message <- @messages do %>
                    <%= if message.sent_by != @user.id do %>
                      <li class="flex items-end" id={"#{message.id}"}>
                        <%= PuppiesWeb.Avatar.show(%{business: @current_thread.receiver.business, user: @current_thread.receiver, square: 10, extra_classes: "text-2xl mx-4"}) %>
                        <div class="p-4 shadow rounded text-sm bg-white">
                          <%= message.message %>
                        </div>
                      </li>
                    <% else %>
                      <li class="flex items-end flex-row-reverse" id={"#{message.id}"}>
                         <%= PuppiesWeb.Avatar.show(%{business: @current_thread.sender.business, user: @current_thread.sender, square: 10, extra_classes: "text-2xl mx-4"}) %>
                        <div class="p-4 shadow rounded text-sm bg-white">
                          <%= message.message %>
                        </div>
                      </li>
                    <% end %>
                  <% end %>
                <% else %>
                  No messages
                <% end %>
              </ul>
              <div class="bg-white absolute bottom-0 w-full border-t-[1px]">
                <div class="p-4">
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
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    """
  end
end
