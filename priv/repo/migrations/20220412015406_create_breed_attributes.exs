defmodule Puppies.Repo.Migrations.CreateBreedAttributes do
  use Ecto.Migration

  def change do
    create table(:breed_attributes) do
      add(:breed_id, references(:breeds, on_delete: :nothing))
      add(:potential_for_playfulness, :integer)
      add(:exercise_needs, :integer)
      add(:intensity, :integer)
      add(:energy_level, :integer)
      add(:wanderlust_potential, :integer)
      add(:tendency_to_bark_or_howl, :integer)
      add(:prey_drive, :integer)
      add(:potential_for_mouthiness, :integer)
      add(:intelligence, :integer)
      add(:easy_to_train, :integer)
      add(:size, :integer)
      add(:potential_for_weight_gain, :integer)
      add(:general_health, :integer)
      add(:easy_to_groom, :integer)
      add(:drooling_potential, :integer)
      add(:amount_of_shedding, :integer)
      add(:friendly_toward_strangers, :integer)
      add(:dog_friendly, :integer)
      add(:kid_friendly, :integer)
      add(:affectionate_with_family, :integer)
      add(:tolerates_hot_weather, :integer)
      add(:tolerates_cold_weather, :integer)
      add(:tolerates_being_alone, :integer)
      add(:sensitivity_level, :integer)
      add(:good_for_novice_owners, :integer)
      add(:adapts_well_to_apartment_living, :integer)
      add(:physical_needs, :integer)
      add(:trainability, :integer)
      add(:health_and_grooming_needs, :integer)
      add(:all_around_friendliness, :integer)
      add(:adaptability, :integer)
      add(:dog_breed_group, :string)
      add(:height, :string)
      add(:weight, :string)
      add(:life_span, :string)
      add(:url, :string)
      timestamps()
    end
  end
end
