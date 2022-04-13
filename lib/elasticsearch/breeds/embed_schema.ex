defmodule Puppies.BreedsSearch do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:name, :string)
    field(:size, :integer)
    field(:size_min, :integer, default: 1)
    field(:size_max, :integer, default: 5)
    field(:kid_friendly, :integer)
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
