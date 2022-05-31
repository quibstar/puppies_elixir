defmodule Puppies.Transactions do
  @moduledoc """
  Transactions module
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.{Transaction, Verification.Credits}

  def get_user_transactions(customer_id) do
    from(s in Transaction,
      where: s.customer_id == ^customer_id,
      order_by: [desc: s.created]
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

  # Invoices
  def check_and_save_stripe_invoice(invoice) do
    unless invoice_exists(invoice.id) do
      item = List.first(invoice.lines.data)
      {:ok, charge} = Stripe.Charge.retrieve(invoice.charge)

      trans = %{
        invoice_id: invoice.id,
        status: invoice.status,
        amount_paid: invoice.amount_paid,
        description: item.description,
        subscription_id: invoice.subscription,
        charge_id: invoice.charge,
        customer_id: invoice.customer,
        created: invoice.created,
        merchant: "stripe",
        reference_number: invoice.number,
        last_4: charge.payment_method_details.card.last4
      }

      create_transaction(trans)
    end
  end

  # Charges

  def verify_charges_has_been_saved(customer_id) do
    {:ok, customer} = Stripe.Charge.list(%{customer: customer_id})

    Enum.each(customer.data, fn charge ->
      check_and_save_stripe_charge(charge)
    end)
  end

  def check_and_save_stripe_charge(charge) do
    # Only listing boosts and ID Verifications should have product name in metadata
    if !charge_exists?(charge.id) && Map.has_key?(charge.metadata, "product") do
      user_id = charge.metadata["user_id"]

      product_name = charge.metadata["product"]

      number =
        if Map.has_key?(charge.metadata, :number) do
          charge.number
        else
          ""
        end

      transaction = %{
        customer_id: charge.customer,
        charge_id: charge.id,
        amount_paid: charge.amount,
        created: charge.created,
        merchant: "stripe",
        refunded: charge.refunded,
        status: charge.status,
        description: product_name,
        reference_number: number,
        last_4: charge.payment_method_details.card.last4
      }

      create_transaction(transaction)

      # Credits are created so the user can be instructed to verify their id.
      if product_name == "ID Verification" do
        maybe_create_credit(user_id, product_name)
      end
    end
  end

  defp maybe_create_credit(user_id, type) do
    if !Credits.has_credit?(user_id, type) do
      Credits.insert_credit(%{user_id: user_id, type: type})
    end
  end

  def charge_exists?(charge_id) do
    Repo.exists?(from(t in Transaction, where: t.charge_id == ^charge_id))
  end
end
