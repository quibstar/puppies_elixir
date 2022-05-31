defmodule Puppies.Admin.SearchSchema do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field(:term, :string)
  end

  @doc false
  def changeset(term, attrs) do
    term
    |> cast(attrs, [
      :term
    ])
    |> validate_required([:term])
  end
end
