defmodule Puppies.ES.Transactions do
  @moduledoc """
  Elasticsearch: creating indexing and deleting indexing
  """
  alias Puppies.{ES.Api, ES.Indexing, Transactions, Accounts}

  def re_index_transactions_by_user_id(user_id) do
    user = Accounts.get_user!(user_id)
    post("transactions", user)
  end

  def create_mappings_and_index() do
    date_time = DateTime.utc_now() |> DateTime.to_unix()
    transaction = "transactions_#{date_time}"

    # Mappings
    transaction_mapping = data_type_mapping()
    Indexing.create_mappings(transaction, transaction_mapping)

    # Api.delete("/transactions")
    Indexing.alias(transaction, "transactions")
    index_transactions(transaction)
  end

  defp index_transactions(index) do
    users = Puppies.Repo.all(Accounts.User)

    Enum.each(users, fn user ->
      post(index, user)
    end)
  end

  defp post(index, user) do
    unless is_nil(user.customer_id) do
      transactions = Transactions.get_user_transactions(user.customer_id)

      Enum.each(transactions, fn transaction ->
        res = transform_to_flat_data(user, transaction)
        Api.post("/#{index}/_doc/#{transaction.id}", res)
      end)
    end
  end

  def delete_all_transactions do
    {:ok, list} = Indexing.get_index("_aliases")
    new_list = Jason.decode!(list)

    Enum.each(new_list, fn l ->
      res = elem(l, 0)

      if String.contains?(res, "transactions") do
        Indexing.delete_index(res)
      end
    end)
  end

  defp transform_to_flat_data(user, transaction) do
    %{
      user_id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      id: transaction.id,
      description: transaction.description,
      reference_number: transaction.reference_number,
      last_4: transaction.last_4
    }
  end

  defp data_type_mapping() do
    %{
      mappings: %{
        properties: %{
          user_id: %{type: :integer},
          first_name: %{type: :text},
          last_name: %{type: :text},
          id: %{type: :integer},
          status: %{type: :keyword},
          description: %{type: :text},
          reference_number: %{type: :keyword},
          last_4: %{type: :keyword}
        }
      }
    }
  end
end
