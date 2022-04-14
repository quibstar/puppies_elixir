defmodule Puppies.BreedsSearch do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
    field(:size, :integer)
    field(:size_min, :integer, default: 1)
    field(:size_max, :integer, default: 5)
    field(:kid_friendly, :integer, default: 3)
    field(:amount_of_shedding, :integer, default: 3)
    field(:dog_friendly, :integer, default: 3)
    field(:intelligence, :integer, default: 3)
    field(:stranger_friendly, :integer, default: 3)
    field(:tendency_to_bark_or_howl, :integer, default: 3)
    field(:trainability, :integer, default: 3)
  end

  @doc false
  def changeset(breed, attrs) do
    breed
    |> cast(attrs, [
      :name,
      :size,
      :kid_friendly
    ])
    |> validate_required([:name])
  end
end
