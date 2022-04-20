defmodule Puppies.Repo.Migrations.CreateReviews do
  use Ecto.Migration

  def change do
    create table(:reviews) do
      add(:rating, :integer)
      add(:review, :text)
      add(:email, :string)
      add(:user_id, :integer)
      add(:business_id, :integer)
      add(:approved, :boolean)

      timestamps()
    end

    create(index(:reviews, [:business_id]))
    create(index(:reviews, [:user_id]))
  end
end
