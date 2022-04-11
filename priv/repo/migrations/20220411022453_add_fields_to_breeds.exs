defmodule Puppies.Repo.Migrations.AddFieldsToBreeds do
  use Ecto.Migration

  def change do
    alter table("breeds") do
      add(:adaptable, :integer)
      add(:friendly, :integer)
      add(:grooming_and_health, :integer)
      add(:trainable, :integer)
      add(:attention_and_exercise, :integer)
    end
  end
end
