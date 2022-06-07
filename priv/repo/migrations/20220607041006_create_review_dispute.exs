defmodule Puppies.Repo.Migrations.CreateReviewDispute do
  use Ecto.Migration

  def change do
    create table(:review_dispute) do
      add(:admin_id, references(:admins, on_delete: :nothing))
      add(:admin_note, :string)
      add(:disputed, :boolean, default: false, null: false)
      add(:reason, :text)
      add(:review_id, references(:reviews, on_delete: :nothing))
      timestamps()
    end

    create(index(:review_dispute, [:admin_id]))
    create(index(:review_dispute, [:review_id]))
  end
end
