defmodule PuppiesWeb.ChatIcon do
  @moduledoc """
  Flag component modal
  """
  use PuppiesWeb, :live_component

  alias PuppiesWeb.{UI.Modal, StartChat}

  def render(assigns) do
    ~H"""
    <div x-data="{ show_modal: false}" >
      <Modal.modal>
        <:modal_title>
          Let's start a conversation
        </:modal_title>

        <:modal_body>
          <.live_component module={StartChat} id={@business.id} business={@business} user={@user} listing={@listing} return_to={ Routes.live_path(@socket, PuppiesWeb.ListingShow, @listing.id)}/>
        </:modal_body>

      </Modal.modal>

      <svg x-on:click.debounce="show_modal = !show_modal" class="w-6 h-6 mr-2 cursor-pointer" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
      </svg>
    </div>
    """
  end
end
