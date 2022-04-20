defmodule Puppies.Repo.Migrations.CreateReviewLinks do
  use Ecto.Migration

  def change do
    create table(:review_links) do
      add(:email, :string)
      add(:uuid, :uuid)
      add(:expired, :boolean, default: false)
      add(:listing_id, references(:listings, on_delete: :nothing))

      timestamps()
    end

    create(index(:review_links, [:listing_id]))
  end
end
