defmodule Puppies.PopularBreed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "popular_breeds" do
    field(:count, :integer)
    field(:slug, :string)
    field(:name, :string)

    timestamps()
  end

  @doc false
  def changeset(popular_Breed, attrs) do
    popular_Breed
    |> cast(attrs, [:slug, :name, :count])
    |> validate_required([:slug, :name, :count])
  end
end
