defmodule Puppies.Transactions do
  @moduledoc """
  Transactions module
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.Transaction

  def get_user_transactions(customer_id) do
    from(s in Transaction,
      where: s.customer_id == ^customer_id
    )
    |> Repo.all()
  end

  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  def invoice_exists(invoice_id) do
    Repo.exists?(
      from(s in Transaction,
        where: s.invoice_id == ^invoice_id
      )
    )
  end
end
