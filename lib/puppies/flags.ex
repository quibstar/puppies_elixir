defmodule Puppies.Flags do
  @moduledoc """
  The Flags context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Flag

  def create(attrs \\ %{}) do
    %Flag{}
    |> Flag.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Flag{} = flag, attrs) do
    flag
    |> Flag.changeset(attrs)
    |> Repo.update()
  end

  def check_for_flag(%{
        "reporter_id" => reporter_id,
        "offender_id" => offender_id,
        "reason" => reason
      }) do
    Repo.exists?(
      from(f in Flag,
        where:
          f.reason == ^reason and f.offender_id == ^offender_id and f.reporter_id == ^reporter_id and
            f.resolved == false
      )
    )
  end

  def check_for_system_reported_flag(%{"offender_id" => offender_id, "type" => type}) do
    Repo.exists?(
      from(f in Flag,
        where: f.type == ^type and f.offender_id == ^offender_id and f.resolved == false
      )
    )
  end

  # for testing
  def get_offender_flags(offender_id) do
    q =
      from(f in Flag,
        where: f.offender_id == ^offender_id
      )

    Repo.all(q)
  end
end
