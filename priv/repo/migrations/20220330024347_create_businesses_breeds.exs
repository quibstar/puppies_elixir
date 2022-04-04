defmodule Puppies.Repo.Migrations.CreateBusinessBreeds do
  use Ecto.Migration

  def change do
    create table(:business_breeds) do
      add :breed_id, references(:breeds, on_delete: :nothing)
      add :business_id, references(:businesses, on_delete: :nothing)

      timestamps()
    end

    create index(:business_breeds, [:breed_id])
    create index(:business_breeds, [:business_id])
  end
end
