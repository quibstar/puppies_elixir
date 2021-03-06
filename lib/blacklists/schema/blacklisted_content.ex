defmodule Puppies.Blacklists.Content do
  use Ecto.Schema
  import Ecto.Changeset

  schema "blacklisted_contents" do
    field(:content, :string)
    belongs_to(:admin, Puppies.Admins.Admin)
    timestamps()
  end

  def changeset(content_blacklist, attrs) do
    content_blacklist
    |> cast(attrs, [:content, :admin_id])
    |> validate_required([:content])
    |> unique_constraint(:content, message: "Already added")
  end
end
