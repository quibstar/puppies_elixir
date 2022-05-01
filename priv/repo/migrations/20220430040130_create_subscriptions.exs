defmodule Puppies.Repo.Migrations.CreateSubscriptions do
  use Ecto.Migration

  def change do
    create table(:subscriptions) do
      add(:product_id, :string)
      add(:cancel_at_period_end, :boolean)
      add(:plan_id, :string)
      add(:amount, :integer)
      add(:subscription_id, :string)
      add(:subscription_status, :string)
      add(:customer_id, :string)
      add(:start_date, :integer)
      add(:end_date, :integer)

      timestamps()
    end
  end
end
