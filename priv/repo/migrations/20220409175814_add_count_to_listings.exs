defmodule Puppies.Repo.Migrations.AddCountToListings do
  use Ecto.Migration

  def change do
    alter table("listings") do
      add(:views, :integer)
    end
  end
end
