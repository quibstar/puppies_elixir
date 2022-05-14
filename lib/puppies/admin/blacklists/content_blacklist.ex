defmodule Puppies.Blacklists.ContentBlacklist do
  use Ecto.Schema
  import Ecto.Changeset

  schema "content_blacklists" do
    field(:content, :string)
    belongs_to(:admin, Puppies.Admins.Admin)
    timestamps()
  end

  @doc false
  def changeset(content_blacklist, attrs) do
    content_blacklist
    |> cast(attrs, [:content, :admin_id])
    |> validate_required([:content])
  end
end
