defmodule Puppies.RecordIPBackgroundJob do
  use Oban.Worker, queue: :events

  alias Puppies.IPStack

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"user_id" => user_id, "ip" => ip}}) do
    IPStack.process_ip(ip, user_id)
    :ok
  end
end
