defmodule Puppies.BreedAttribute do
  use Ecto.Schema
  import Ecto.Changeset

  schema "breed_attributes" do
    field(:adaptability, :integer)
    field(:adapts_well_to_apartment_living, :integer)
    field(:affectionate_with_family, :integer)
    field(:all_around_friendliness, :integer)
    field(:amount_of_shedding, :integer)
    field(:dog_friendly, :integer)
    field(:drooling_potential, :integer)
    field(:easy_to_groom, :integer)
    field(:easy_to_train, :integer)
    field(:energy_level, :integer)
    field(:exercise_needs, :integer)
    field(:friendly_toward_strangers, :integer)
    field(:general_health, :integer)
    field(:good_for_novice_owners, :integer)
    field(:health_and_grooming_needs, :integer)
    field(:intelligence, :integer)
    field(:intensity, :integer)
    field(:kid_friendly, :integer)
    field(:physical_needs, :integer)
    field(:potential_for_mouthiness, :integer)
    field(:potential_for_playfulness, :integer)
    field(:potential_for_weight_gain, :integer)
    field(:prey_drive, :integer)
    field(:sensitivity_level, :integer)
    field(:size, :integer)
    field(:tendency_to_bark_or_howl, :integer)
    field(:tolerates_being_alone, :integer)
    field(:tolerates_cold_weather, :integer)
    field(:tolerates_hot_weather, :integer)
    field(:trainability, :integer)
    field(:wanderlust_potential, :integer)
    belongs_to(:breed, Puppies.Dogs.Breed)

    timestamps()
  end

  @doc false
  def changeset(breed_attribute, attrs) do
    breed_attribute
    |> cast(attrs, [
      :breed_id,
      :potential_for_playfulness,
      :exercise_needs,
      :intensity,
      :energy_level,
      :wanderlust_potential,
      :tendency_to_bark_or_howl,
      :prey_drive,
      :potential_for_mouthiness,
      :intelligence,
      :easy_to_train,
      :size,
      :potential_for_weight_gain,
      :general_health,
      :easy_to_groom,
      :drooling_potential,
      :amount_of_shedding,
      :friendly_toward_strangers,
      :dog_friendly,
      :kid_friendly,
      :affectionate_with_family,
      :tolerates_hot_weather,
      :tolerates_cold_weather,
      :tolerates_being_alone,
      :sensitivity_level,
      :good_for_novice_owners,
      :adapts_well_to_apartment_living,
      :physical_needs,
      :trainability,
      :health_and_grooming_needs,
      :all_around_friendliness,
      :adaptability
    ])
  end
end
