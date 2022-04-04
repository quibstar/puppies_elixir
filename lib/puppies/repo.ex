defmodule Puppies.Repo do
  use Ecto.Repo,
    otp_app: :puppies,
    adapter: Ecto.Adapters.Postgres
end
