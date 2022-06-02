defmodule Puppies.ES.AdminSearch do
  alias Puppies.ES.UserQuery

  def query(term) do
    UserQuery.user_query(term)
  end
end
