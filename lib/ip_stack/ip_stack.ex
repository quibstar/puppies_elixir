defmodule Puppies.IPStack do
  @moduledoc """
  Send events to the captain
  """

  alias Puppies.IPStack.Api
  alias Puppies.IPData
  alias Puppies.Repo
  import Ecto.Query, warn: false

  def process_ip(ip_address, user_id) do
    # ip_address = "24.204.172.199"
    ip_data = record_exist(ip_address, user_id)

    if is_nil(ip_data) do
      response = Api.get(ip_address)

      case response do
        {:ok, body} ->
          data = Jason.decode!(body)

          get_required_fields(data, user_id)
          |> create_ip_data()

        {:error, error} ->
          IO.puts("ip stack error: #{error}")
      end
    else
      # updates the `updated_at` field
      update_ip_data(ip_data)
    end
  end

  def get_required_fields(data, user_id) do
    %{
      ip: data["ip"],
      type: data["type"],
      continent_code: data["continent_code"],
      continent_name: data["continent_name"],
      country_code: data["country_code"],
      country_name: data["country_name"],
      region_code: data["region_code"],
      region_name: data["region_name"],
      city: data["city"],
      zip: data["zip"],
      latitude: data["latitude"],
      longitude: data["longitude"],
      time_zone: data["time_zone"]["id"],
      isp: data["connection"]["isp"],
      user_id: user_id
    }
  end

  def get_ip_data_by_user(user_id) do
    Repo.all(
      from(i in IPData,
        where: i.user_id == ^user_id
      )
    )
  end

  def create_ip_data(attrs) do
    %IPData{}
    |> IPData.changeset(attrs)
    |> Repo.insert()
  end

  def update_ip_data(%IPData{} = ip_data) do
    ip_data
    |> IPData.changeset(%{})
    |> Repo.update(force: true)
  end

  def record_exist(ip_address, user_id) do
    Repo.one(from(i in IPData, where: i.ip == ^ip_address and i.user_id == ^user_id))
  end
end
