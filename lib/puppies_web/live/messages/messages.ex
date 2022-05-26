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

    PuppiesWeb.Endpoint.subscribe("user-#{user.id}")

    threads = Threads.get_user_threads(user.id)

    if threads == [] do
      {:ok,
       assign(socket,
         loading: false,
         user: user,
         threads: threads
       )}
    else
      unless is_nil(params["thread"]) do
        Messages.mark_messages_as_read_by_user_and_thread_uuid(user.id, params["thread"])
      end

      current_thread = Threads.get_first_listing_thread_and_messages(user.id)

      changeset = Messages.message_changes(%{})

      subscribe(current_thread.uuid)

      update_self(socket.assigns)

      listing_threads =
        if user.is_seller do
          if is_nil(params["uuid"]) do
            nil
          else
            Threads.get_threads_by_user_and_listing(user.id, params["listing_id"])
          end
        else
          Threads.buyer_threads(user.id)
        end

      if user.is_seller do
        socket =
          if(is_nil(params["listing_id"] && is_nil(params["thread"]))) do
            assign(socket, :messages, [])
          else
            assign(socket, :messages, current_thread.messages)
          end

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
      else
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
    end
  end

  def subscribe(thread_id) do
    PuppiesWeb.Endpoint.subscribe(thread_id)
  end

  def unsubscribe_subscribe(old_thread_id, new_thread_id) do
    PuppiesWeb.Endpoint.unsubscribe(old_thread_id)
    subscribe(new_thread_id)
  end

  def handle_params(params, _uri, socket) do
    cond do
      Map.has_key?(params, "listing_id") && socket.assigns.loading == false ->
        listing_params(params, socket)

      Map.has_key?(params, "thread") && socket.assigns.loading == false ->
        thread_params(params, socket)

      true ->
        update_self(socket.assigns)
        {:noreply, socket}
    end
  end

  def listing_params(params, socket) do
    %{"listing_id" => listing_id} = params

    user_id = socket.assigns.user.id

    unless is_nil(params["thread"]) do
      Messages.mark_messages_as_read_by_user_and_thread_uuid(user_id, params["thread"])
    end

    listing_threads = Threads.get_threads_by_user_and_listing(user_id, listing_id)

    listing = Listings.get_listing(listing_id)

    current_thread =
      if is_nil(params["thread"]) do
        thread = List.first(listing_threads)
        unsubscribe_subscribe(socket.assigns.current_thread.uuid, thread.uuid)
        thread
      else
        unsubscribe_subscribe(socket.assigns.current_thread.uuid, params["thread"])
        Threads.current_thread(socket.assigns.user.id, params["thread"])
      end

    socket = assign(socket, :messages, current_thread.messages)

    update_self(socket.assigns)

    socket =
      assign(
        socket,
        listing_threads: listing_threads,
        listing: listing,
        current_thread: current_thread,
        temporary_assigns: [messages: []]
      )

    {:noreply, socket}
  end

  def thread_params(params, socket) do
    %{"thread" => thread} = params

    user_id = socket.assigns.user.id

    Messages.mark_messages_as_read_by_user_and_thread_uuid(user_id, thread)

    unsubscribe_subscribe(socket.assigns.current_thread.uuid, thread)
    current_thread = Threads.current_thread(socket.assigns.user.id, thread)

    socket = assign(socket, :messages, current_thread.messages)

    update_self(socket.assigns)

    socket =
      assign(
        socket,
        current_thread: current_thread,
        temporary_assigns: [messages: []]
      )

    {:noreply, socket}
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
        uuid = socket.assigns.current_thread.uuid
        Threads.updated_threads(message.thread_uuid, %{last_message: message.message})

        PuppiesWeb.Endpoint.broadcast_from(
          self(),
          "user-#{message.received_by}",
          "update_self",
          %{message: message, thread: uuid}
        )

        PuppiesWeb.Endpoint.broadcast_from(
          self(),
          "messages:user:#{message.received_by}",
          "update_messages_count",
          %{user_id: message.received_by}
        )

        socket =
          socket
          |> update(:messages, fn messages -> messages ++ [message] end)

        {:noreply,
         assign(socket,
           changeset: changeset
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def update_self(assigns) do
    if Map.has_key?(assigns, :user) do
      PuppiesWeb.Endpoint.broadcast_from(
        self(),
        "messages:user:#{assigns.user.id}",
        "update_messages_count",
        %{user_id: assigns.user.id}
      )
    end
  end

  def handle_info(%{event: "update_self", payload: state}, socket) do
    user_id = socket.assigns.user.id

    socket =
      if Map.has_key?(state, :thread) && state.thread == socket.assigns.current_thread.uuid do
        Messages.mark_messages_as_read_by_user_and_thread_uuid(user_id, state.thread)

        socket
        |> update(:messages, fn messages -> messages ++ [state.message] end)
      else
        socket
      end

    if Map.has_key?(socket.assigns, :listing) do
      listing_threads =
        Threads.get_threads_by_user_and_listing(user_id, socket.assigns.listing.id)

      {:noreply,
       assign(socket,
         listing_threads: listing_threads
       )}
    else
      threads = Threads.get_user_threads(user_id)

      {:noreply,
       assign(socket,
         threads: threads
       )}
    end
  end

  def render(assigns) do
    ~H"""
      <div class='h-full'>
        <%= if @loading do %>
          <%= live_component PuppiesWeb.LoadingComponent, id: "listing-loading" %>
        <% else  %>
          <%= if @threads == [] do %>
            <div class="h-full flex justify-center items-center mx-auto">
              <div class="text-center">
                  <svg class="mx-auto h-12 w-12 text-gray-400" xmlns="http://www.w3.org/2000/svg"  fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                  </svg>
                  <h3 class="mt-2 text-sm font-medium text-gray-900">No messages</h3>
                  <p class="mt-1 text-sm text-gray-500">
                    Person of little words, we can appreciate that.
                  </p>
              </div>
            </div>
          <% else %>
            <%= if @user.is_seller do %>
              <.live_component module={PuppiesWeb.SellerMessageCenter} id="seller-message-center" user={@user} threads={@threads} listing_threads={@listing_threads} current_thread={@current_thread} changeset={@changeset} messages={@messages} />
            <% else %>
              <.live_component module={PuppiesWeb.BuyerMessageCenter} id="buyer-message-center" user={@user} listing_threads={@listing_threads} current_thread={@current_thread} changeset={@changeset} messages={@messages} />
            <% end %>
          <% end %>
        <% end %>
      </div>
    """
  end
end
