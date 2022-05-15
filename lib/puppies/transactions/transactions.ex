defmodule Puppies.Transaction do
  use Ecto.Schema
  import Ecto.Changeset

  schema "transactions" do
    field(:charge_id, :string)
    field(:customer_id, :string)
    field(:invoice_id, :string)
    field(:merchant, :string)
    field(:status, :string)
    field(:subscription_id, :string)
    field(:description, :string)
    field(:created, :integer)
    field(:refunded, :boolean, default: false)
    field(:refund_id, :string)
    field(:admin_id, :integer)
    field(:reference_number, :string)

    has_one(:admin, Puppies.Admins.Admin,
      references: :admin_id,
      foreign_key: :id
    )

    timestamps()
  end

  @doc false
  def changeset(invoice, attrs) do
    invoice
    |> cast(attrs, [
      :invoice_id,
      :status,
      :subscription_id,
      :charge_id,
      :customer_id,
      :merchant,
      :description,
      :created,
      :refunded,
      :refund_id,
      :admin_id,
      :reference_number
    ])
    |> validate_required([
      :status,
      :charge_id,
      :customer_id,
      :merchant,
      :created
    ])
  end
end
