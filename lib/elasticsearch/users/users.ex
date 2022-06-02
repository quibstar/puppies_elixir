defmodule Puppies.ES.Users do
  @moduledoc """
  Elasticsearch: creating indexing and deleting indexing
  """
  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.{ES.Api, ES.Indexing, Accounts.User}

  def re_index_user(id) do
    user = user_query(id)
    res = transform_to_flat_data(user)
    Api.post("/users/_doc/#{user.id}", res)
  end

  @spec create_mappings_and_index :: :ok
  def create_mappings_and_index() do
    date_time = DateTime.utc_now() |> DateTime.to_unix()
    index_name = "users_#{date_time}"

    # Mappings
    user_mapping = data_type_mapping()
    Indexing.create_mappings(index_name, user_mapping)

    # Api.delete("/users")
    Indexing.alias(index_name, "users")
    index_users(index_name)
  end

  defp index_users(index) do
    users =
      User
      |> preload([
        :listings,
        :ip_addresses,
        :transactions,
        [business: [:breeds, :location, :business_breeds]]
      ])
      |> Puppies.Repo.all()

    Enum.each(users, fn user ->
      res = transform_to_flat_data(user)

      Api.post("/#{index}/_doc/#{user.id}", res)
    end)
  end

  def delete_all_users_indexes do
    {:ok, list} = Indexing.get_index("_aliases")
    new_list = Jason.decode!(list)

    Enum.each(new_list, fn l ->
      res = elem(l, 0)

      if String.contains?(res, "users") do
        Indexing.delete_index(res)
      end
    end)
  end

  defp user_query(id) do
    q =
      from(u in User,
        where: u.id == ^id
      )
      |> preload([:listings, [business: [:breeds, :location, :business_breeds]]])

    Repo.one(q)
  end

  defp transform_to_flat_data(user) do
    business = user.business
    listings = user.listings

    %{
      id: user.id,
      email: user.email,
      name: user.first_name <> " " <> user.last_name,
      user_phone_number: business.phone_number,
      ip_address: ip_addresses_to_list(user.ip_addresses),
      transactions_last_4: transactions_last_4(user.transactions),
      transactions_reference_number: transactions_reference_numbers(user.transactions),
      business_name: business.name,
      business_description: business.description,
      business_phone_number: business.phone_number,
      listing_descriptions:
        Enum.reduce(listings, [], fn listing, acc -> [listing.description | acc] end)
    }
  end

  def ip_addresses_to_list(ip_addresses) do
    Enum.reduce(ip_addresses, [], fn ip_address, acc ->
      [ip_address.ip | acc]
    end)
  end

  def transactions_last_4(transactions) do
    Enum.reduce(transactions, [], fn transaction, acc ->
      [transaction.last_4 | acc]
    end)
  end

  def transactions_reference_numbers(transactions) do
    Enum.reduce(transactions, [], fn transaction, acc ->
      [transaction.reference_number | acc]
    end)
  end

  defp data_type_mapping() do
    %{
      mappings: %{
        properties: %{
          id: %{type: :long},
          name: %{type: :text},
          email: %{type: :keyword},
          phone_number: %{type: :keyword},
          business_name: %{type: :keyword},
          business_description: %{type: :keyword},
          breeds_slug: %{type: :keyword},
          business_phone_number: %{type: :keyword},
          website: %{type: :keyword},
          listing_descriptions: %{type: :text}
        }
      }
    }
  end
end
