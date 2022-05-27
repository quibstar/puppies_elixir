defmodule Puppies.RecordActivityBackgroundJob do
  use Oban.Worker, queue: :activity

  alias Puppies.Activities

  @impl Oban.Worker
  def perform(%Oban.Job{args: args}) do
    Activities.create_activity(args)
    :ok
  end
end
