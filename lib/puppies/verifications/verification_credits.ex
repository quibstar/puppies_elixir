defmodule Puppies.Verification.Credits do
  @moduledoc """
  Verification module
  """
  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.VerificationCredit

  def has_credit?(user_id, type) do
    Repo.exists?(from(v in VerificationCredit, where: v.user_id == ^user_id and v.type == ^type))
  end

  def insert_credit(attrs) do
    VerificationCredit.changeset(%VerificationCredit{}, attrs)
    |> Repo.insert()
  end

  def update_credit(verification, attrs) do
    verification
    |> VerificationCredit.changeset(attrs)
    |> Repo.update()
  end

  def delete_credit(user_id, type) do
    from(v in VerificationCredit, where: v.user_id == ^user_id and v.type == ^type)
    |> Repo.delete_all()
  end
end
