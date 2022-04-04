defmodule Puppies.Repo.Migrations.CreateCharacteristics do
  use Ecto.Migration

  def change do
    create table(:attributes) do
      add :attribute, :string

      timestamps()
    end
  end
end
