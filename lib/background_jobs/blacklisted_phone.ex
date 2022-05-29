defmodule Puppies.RecordPhoneBackgroundJob do
  use Oban.Worker, queue: :events

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id, "phone_number" => phone_number}}) do
    Puppies.BlacklistsProcessor.check_for_banned_phone_number(user_id, phone_number)
    :ok
  end
end
