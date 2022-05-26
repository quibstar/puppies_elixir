defmodule Puppies.Repo.Migrations.CreateThreads do
  use Ecto.Migration

  def change do
    create table(:threads) do
      add(:uuid, :uuid)
      add(:sender_id, references(:users, on_delete: :nothing))
      add(:receiver_id, references(:users, on_delete: :nothing))
      add(:listing_id, references(:listings, on_delete: :nothing))
      add(:business_id, :integer)

      timestamps()
    end

    create(index(:threads, [:sender_id]))
    create(index(:threads, [:listing_id]))
    create(index(:threads, [:uuid]))
    create(index(:threads, [:business_id]))
  end
end
