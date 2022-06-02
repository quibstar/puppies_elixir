defmodule Puppies.ReindexUserBackgroundJob do
  use Oban.Worker, queue: :events
  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id}}) do
    Puppies.ES.Users.re_index_user(user_id)
    :ok
  end
end
