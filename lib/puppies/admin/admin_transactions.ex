defmodule Puppies.Admin.Transactions do
  @moduledoc """
  Flags context
  """
  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.Transaction

  def transactions(customer_id) do
    q =
      from(o in Transaction,
        where: o.customer_id == ^customer_id,
        order_by: [desc: :created],
        preload: [:admin]
      )

    Repo.all(q)
  end

  def update(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  def get!(id) do
    Transaction
    |> Repo.get(id)
  end
end
