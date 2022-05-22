defmodule Puppies.Repo.Migrations.AddLockedToUsers do
  use Ecto.Migration

  def change do
    alter table("users") do
      add(:locked, :boolean, default: false)
    end
  end
end
