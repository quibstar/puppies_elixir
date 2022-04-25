defmodule Puppies.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add(:sent_by, :integer)
      add(:received_by, :integer)
      add(:read, :boolean, default: false, null: false)
      add(:message, :text)
      add(:thread_uuid, :uuid)

      timestamps()
    end

    create(index(:messages, [:thread_uuid]))
  end
end
