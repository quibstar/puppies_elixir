defmodule Puppies.Admin.Notes do
  @moduledoc """
  Notes context
  """
  alias Puppies.User.Note
  import Ecto.Query, warn: false
  alias Puppies.Repo

  def user_notes(user_id) do
    q =
      from(n in Note,
        where: n.user_id == ^user_id,
        order_by: [desc: n.inserted_at]
      )

    Repo.all(q)
  end

  def get_note!(id), do: Repo.get!(Note, id)

  def create(attrs \\ %{}) do
    %Note{}
    |> Note.changeset(attrs)
    |> Repo.insert()
  end

  def update(%Note{} = note, attrs) do
    note
    |> Note.changeset(attrs)
    |> Repo.update()
  end

  def delete_note(%Note{} = note) do
    Repo.delete(note)
  end

  def change_note(%Note{} = note, attrs \\ %{}) do
    Note.changeset(note, attrs)
  end
end
