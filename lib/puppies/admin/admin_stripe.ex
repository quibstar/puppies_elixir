defmodule Puppies.Admin.Stripe do
  alias Puppies.Admin.Transactions

  def refund(transaction_id, admin) do
    transaction = Transactions.get!(transaction_id)
    {:ok, refund} = Stripe.Refund.create(%{charge: transaction.charge_id})

    if refund.status == "succeeded" do
      Transactions.update(transaction, %{
        refund_id: refund.id,
        refunded: true,
        admin_id: admin.id
      })
    else
      {:error, "Stripe Error"}
    end
  end
end
