defmodule Puppies.SubscriptionsTest do
  use Puppies.DataCase

  alias Puppies.Subscriptions
  alias Puppies.Stripe
  alias Puppies.Accounts
  import Puppies.{AccountsFixtures, StripeResponsesFixtures}

  setup do
    user = user_fixture()
    {:ok, user} = Accounts.save_stripe_customer_id(user, %{customer_id: "cus_LarwV9mynfwkOR"})
    {:ok, user: user}
  end

  describe "Subscriptions" do
    test "create new sub", %{user: user} do
      object = customer_subscription_updated()

      Stripe.process_subscription(object)

      user_subscriptions = Subscriptions.get_user_subscriptions(user.customer_id)
      assert(length(user_subscriptions) == 1)

      Stripe.process_subscription(object)

      # still should be one because it updates the current subscription (same subscription_id)
      assert(length(user_subscriptions) == 1)
    end
  end
end
