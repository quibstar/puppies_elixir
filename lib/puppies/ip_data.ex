defmodule Puppies.IPData do
  @moduledoc """
  The Flags context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.IPDatum

  def get_ip_data_by_user(user_id) do
    Repo.all(
      from(i in IPDatum,
        where: i.user_id == ^user_id
      )
    )
  end

  def create(attrs \\ %{}) do
    %IPDatum{}
    |> IPDatum.changeset(attrs)
    |> Repo.insert()
  end

  def update(%IPDatum{} = ip_data) do
    ip_data
    |> IPDatum.changeset(%{})
    |> Repo.update(force: true)
  end

  def record_exist(ip_address, user_id) do
    Repo.one(from(i in IPDatum, where: i.ip == ^ip_address and i.user_id == ^user_id))
  end
end
