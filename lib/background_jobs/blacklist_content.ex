defmodule Puppies.RecordContentBackgroundJob do
  use Oban.Worker, queue: :events

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id, "content" => content, "area" => area}}) do
    Puppies.BlacklistsProcessor.check_content_has_blacklisted_phrase(user_id, content, area)
    :ok
  end
end
