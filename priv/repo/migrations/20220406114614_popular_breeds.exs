defmodule Puppies.Repo.Migrations.PopularBreeds do
  use Ecto.Migration

  def change do
    create table(:popular_breeds) do
      add(:name, :string)
      add(:slug, :string)
      add(:count, :integer)

      timestamps()
    end

    create(index(:popular_breeds, [:slug]))
  end
end
