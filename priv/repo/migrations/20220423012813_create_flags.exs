defmodule Puppies.Repo.Migrations.CreateFlags do
  use Ecto.Migration

  def change do
    create table(:flags) do
      add(:reason, :string)
      add(:resolved, :boolean, default: false, null: false)
      add(:system_reported, :boolean, default: false, null: false)
      add(:offender_id, references(:users, on_delete: :nothing))
      add(:reporter_id, references(:users, on_delete: :nothing))
      add(:type, :string)
      add(:custom_reason, :string)
      timestamps()
    end

    create(index(:flags, [:offender_id]))
    create(index(:flags, [:reporter_id]))
  end
end
