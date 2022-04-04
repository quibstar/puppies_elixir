defmodule Puppies.Repo.Migrations.CreateBreeds do
  use Ecto.Migration

  def change do
    create table(:breeds) do
      add :name, :string
      add :category, :string
      add :slug, :string

      timestamps()
    end
  end
end
