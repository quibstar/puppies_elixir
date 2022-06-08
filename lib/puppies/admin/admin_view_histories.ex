defmodule Puppies.Admin.ViewHistories do
  @moduledoc """
  Notes context
  """
  alias Puppies.Admin.ViewHistory
  import Ecto.Query, warn: false
  alias Puppies.Repo

  def history(admin_id) do
    q =
      from(vh in ViewHistory,
        where: vh.admin_id == ^admin_id,
        order_by: [desc: vh.inserted_at],
        preload: [user: [business: :photo]]
      )

    Repo.all(q)
  end

  def create_or_update(admin_id, user_id) do
    vh =
      Repo.one(
        from(vh in ViewHistory, where: vh.admin_id == ^admin_id and vh.user_id == ^user_id)
      )

    if is_nil(vh) do
      create(%{admin_id: admin_id, user_id: user_id})
      # else
      #   update(vh)
    end
  end

  def create(attrs \\ %{}) do
    %ViewHistory{}
    |> ViewHistory.changeset(attrs)
    |> Repo.insert()
  end

  def update(%ViewHistory{} = view_history) do
    view_history
    |> ViewHistory.changeset(%{})
    |> Repo.update(force: true)
  end

  def delete(%ViewHistory{} = record) do
    Repo.delete(record)
  end
end
