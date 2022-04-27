defmodule Puppies.Repo.Migrations.AddReputationLevelToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:reputation_level, :integer, default: 0)
    end
  end
end
