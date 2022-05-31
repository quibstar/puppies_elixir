defmodule Puppies.TransactionsTest do
  use Puppies.DataCase

  alias Puppies.Transactions
  alias Puppies.Stripe
  alias Puppies.Accounts
  import Puppies.{AccountsFixtures, StripeResponsesFixtures}

  setup do
    user = user_fixture()
    {:ok, user} = Accounts.save_stripe_customer_id(user, %{customer_id: "cus_LarwV9mynfwkOR"})
    {:ok, user: user}
  end

  describe "Transactions" do
    test "save transaction", %{user: user} do
      charge = charge(user.customer_id)
      res = Transactions.check_and_save_stripe_charge(charge.object)
      transactions = Transactions.get_user_transactions(user.customer_id)
      # TODO: test transactions
      # assert(transactions != [])
      # transaction = List.first(transactions)
      # assert(transaction.customer_id == charge.object.customer_id)
      # assert(transaction.description == charge.metadata.product)
      # assert(transaction.last_4 == "4242")
    end
  end
end
