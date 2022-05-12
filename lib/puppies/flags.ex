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

  def get_flags_by_user_id(user_id) do
    q =
      from(f in Flag,
        where: f.user_id == ^user_id
      )

    Repo.all(q)
  end

  def check_for_flag(%{"reporter_id" => reporter_id, "reason" => reason}) do
    Repo.exists?(
      from(f in Flag,
        where: f.reason == ^reason and f.reporter_id == ^reporter_id and f.resolved == false
      )
    )
  end
end
