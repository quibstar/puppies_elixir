defmodule Puppies.Repo.Migrations.CreateContacts do
  use Ecto.Migration

  def change do
    create table(:contacts) do
      add(:first_name, :string)
      add(:last_name, :string)
      add(:email, :string)
      add(:message, :string)
      add(:read, :boolean, default: false)
      timestamps()
    end
  end
end
