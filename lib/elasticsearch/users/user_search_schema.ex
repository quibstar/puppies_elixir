defmodule Puppies.SearchUser do
  import Ecto.Changeset
  use Ecto.Schema

  @primary_key {:id, :integer, []}
  embedded_schema do
    field(:name)
    field(:email)
    field(:highlight, :map)
  end

  def changeset(attrs) do
    %Puppies.SearchUser{}
    |> cast(attrs, [
      :id,
      :name,
      :email,
      :highlight
    ])
  end

  def transform(data) do
    c = changeset(data)
    apply_action!(c, :update)
  end
end
