defmodule PuppiesWeb.NotificationsLive do
  @moduledoc """
  Loading component
  """
  use PuppiesWeb, :live_view

  def render(assigns) do
    ~H"""
      <div class='flex h-full' x-data="{ open: false }">
        Notifications
      </div>
    """
  end
end
