defmodule Puppies.BusinessBreed do
  use Ecto.Schema
  import Ecto.Changeset

  schema "business_breeds" do
    belongs_to :business, Puppies.Businesses.Business
    belongs_to :breed, Puppies.Dogs.Breed

    timestamps()
  end

  @doc false
  def changeset(business_breed, attrs) do
    business_breed
    |> cast(attrs, [:breed_id, :business_id])
  end
end
