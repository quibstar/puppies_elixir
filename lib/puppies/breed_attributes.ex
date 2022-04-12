defmodule Puppies.BreedAttributes do
  @moduledoc """
  Attributes for a breed
  """
  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.{BreedAttribute}

  def get_attributes_for_breed(id) do
    q =
      from(b in BreedAttribute,
        where: b.breed_id == ^id
      )

    Repo.one(q)
  end
end
