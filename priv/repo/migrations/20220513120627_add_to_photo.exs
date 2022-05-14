defmodule Puppies.Repo.Migrations.AddToPhoto do
  use Ecto.Migration

  def change do
    alter table("photos") do
      add(:mark_for_deletion, :boolean, default: false)
      add(:approved, :boolean, default: false)
      add(:resized, :boolean, default: false, null: false)
    end
  end
end
