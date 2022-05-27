defmodule Puppies.BlacklistEmailBackgroundJob do
  use Oban.Worker, queue: :blacklist

  alias Puppies.BlacklistsProcessor

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id, "email" => email}}) do
    BlacklistsProcessor.check_user_email_for_banned_domain(user_id, email)

    :ok
  end
end
