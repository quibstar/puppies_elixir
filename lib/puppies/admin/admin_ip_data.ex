defmodule Puppies.Admin.IPDatum do
  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.IPDatum
  # Admin
  def get_ip_addresses_by_user_id(user_id) do
    res =
      Repo.all(
        from(p in IPDatum,
          where: p.user_id == ^user_id
        )
      )

    Enum.reduce(res, [], fn ip, acc ->
      data = Map.put(ip, :matches, get_ip_data_count_by_ip(ip.ip, ip.user_id))
      [data | acc]
    end)
  end

  def get_ip_data_count_by_ip(ip, user_id) do
    q = from(i in IPDatum, where: i.ip == ^ip and i.user_id != ^user_id)

    Repo.aggregate(
      q,
      :count,
      :id
    )
  end

  def get_ip_data_by_ip(ip_id) do
    ip_data =
      IPDatum
      |> Repo.get(ip_id)

    Repo.all(
      from(i in IPDatum, where: i.ip == ^ip_data.ip and i.user_id != ^ip_data.user_id)
      |> preload(user: :photos)
    )
  end
end
