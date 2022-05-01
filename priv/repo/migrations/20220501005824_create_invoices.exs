defmodule Puppies.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add(:invoice_id, :string)
      add(:status, :string)
      add(:subscription_id, :string)
      add(:charge_id, :string)
      add(:customer_id, :string)
      add(:merchant, :string)
      add(:description, :string)
      add(:created, :integer)
      add(:refunded, :boolean, default: false)
      add(:refund_id, :string)
      add(:admin_id, :integer)
      add(:reference_number, :string)

      timestamps()
    end
  end
end
