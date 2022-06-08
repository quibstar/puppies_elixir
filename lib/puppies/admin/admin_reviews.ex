defmodule Puppies.Admin.Reviews do
  @moduledoc """
  The Reviews context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Reviews.Review

  def get_reviews_by_user(user_id) do
    from(r in Review,
      where: r.user_id == ^user_id,
      preload: [[user: :photo], [business: [user: :photo]], :reply, :dispute]
    )
    |> Repo.all()
  end
end
