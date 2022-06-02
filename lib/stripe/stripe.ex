defmodule Puppies.Stripe do
  alias Puppies.{Accounts, Transactions, Products}
  import Stripe.Request

  def get_products() do
    # {:ok, products} = Stripe.Product.list()

    {:ok, plans} = Stripe.Plan.list()

    Enum.each(plans.data, fn plan ->
      {:ok, product} = Stripe.Product.retrieve(plan.product)
      IO.inspect(product)

      if product.active do
        Products.create_product(%{
          product_id: product.id,
          name: product.name,
          price_id: plan.id,
          unit_amount: plan.amount
        })
      end
    end)
  end

  def get_customer(customer_id) do
    {:ok, customer} = Stripe.Charge.list(%{customer: customer_id})
    customer
  end

  def create_subscription(user, price_id) do
    customer_id = check_for_customer_id(user)

    {:ok, response} =
      Stripe.Subscription.create(%{
        customer: customer_id,
        items: [
          %{
            price: price_id
          }
        ],
        payment_behavior: "default_incomplete",
        expand: ["latest_invoice.payment_intent"]
      })

    %{
      subscription_id: response.id,
      client_secret: response.latest_invoice.payment_intent.client_secret
    }
  end

  def check_for_customer_id(user) do
    if Map.has_key?(user, :customer_id) && user.customer_id != nil do
      user.customer_id
    else
      {:ok, response} =
        Stripe.Customer.create(%{"email" => user.email, "metadata[user_id]" => user.id})

      Accounts.save_stripe_customer_id(user, %{customer_id: response.id})
      response.id
    end
  end

  def update_subscription_payment_method(data_object) do
    if data_object.billing_reason == "subscription_create" do
      subscription_id = data_object.subscription
      payment_intent_id = data_object.payment_intent

      {:ok, payment_intent} = Stripe.PaymentIntent.retrieve(payment_intent_id, %{})

      Stripe.Subscription.update(
        subscription_id,
        %{default_payment_method: payment_intent.payment_method}
      )
    end
  end

  def process_subscription(data_object) do
    Puppies.Subscriptions.create_or_save_subscription(data_object)
  end

  def get_subscriptions(customer_id) do
    {:ok, res} = Stripe.Subscription.list(%{customer: customer_id})

    Enum.each(res.data, fn subscription ->
      if subscription.status == "active" do
        Puppies.Subscriptions.create_or_save_subscription(subscription)
      end
    end)
  end

  def get_invoices(customer_id) do
    {:ok, res} = Stripe.Invoice.list(%{customer: customer_id})

    Enum.each(res.data, fn invoice ->
      if invoice.status == "paid" do
        Transactions.check_and_save_stripe_invoice(invoice)
      end
    end)
  end

  def get_charges(customer_id) do
    {:ok, res} = Stripe.Charge.list(%{customer: customer_id})

    Enum.each(res.data, fn charge ->
      if charge.status == "succeeded" do
        Transactions.check_and_save_stripe_charge(charge)
      end
    end)
  end

  def payment_intent(product, user) do
    customer_id = check_for_customer_id(user)

    {:ok, response} =
      Stripe.PaymentIntent.create(%{
        amount: product.unit_amount,
        currency: "usd",
        customer: customer_id,
        metadata: %{user_id: user.id, product: product.name}
      })

    response
  end

  def create_identity_verification_session(user_id) do
    params = %{
      type: "document",
      metadata: %{
        user_id: user_id
      }
    }

    new_request()
    |> put_endpoint("identity/verification_sessions")
    |> put_params(params)
    |> put_method(:post)
    |> make_request()
  end

  def get_payment_intent(pi) do
    {:ok, response} = Stripe.PaymentIntent.retrieve(pi, %{})
    response
  end
end
