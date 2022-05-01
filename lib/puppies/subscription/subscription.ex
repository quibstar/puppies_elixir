defmodule Puppies.Subscription do
  @moduledoc """
  relation with user is on customer_id
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscriptions" do
    field(:customer_id, :string)
    field(:cancel_at_period_end, :boolean)
    field(:end_date, :integer)
    field(:product_id, :string)
    field(:start_date, :integer)
    field(:subscription_id, :string)
    field(:subscription_status, :string)
    field(:plan_id, :string)
    field(:amount, :integer)

    has_one(:product, Puppies.Product,
      references: :product_id,
      foreign_key: :product_id
    )

    timestamps()
  end

  @doc false
  def changeset(subscription, attrs) do
    subscription
    |> cast(attrs, [
      :product_id,
      :subscription_id,
      :subscription_status,
      :customer_id,
      :start_date,
      :end_date,
      :plan_id,
      :amount,
      :cancel_at_period_end
    ])
    |> validate_required([
      :product_id,
      :subscription_id,
      :subscription_status,
      :customer_id,
      :start_date,
      :end_date,
      :plan_id,
      :amount
    ])
  end
end
