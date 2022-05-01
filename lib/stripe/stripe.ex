defmodule Puppies.Stripe do
  alias Puppies.{Accounts, Subscriptions, Transactions}
  import Stripe.Request

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
    line_item = List.first(data_object.items.data)

    sub = %{
      customer_id: data_object.customer,
      subscription_id: data_object.id,
      subscription_status: data_object.status,
      product_id: line_item.plan.product,
      cancel_at_period_end: data_object.cancel_at_period_end,
      amount: line_item.price.unit_amount,
      end_date: data_object.current_period_end,
      start_date: data_object.current_period_start,
      plan_id: line_item.plan.id
    }

    if Subscriptions.subscription_exists(sub.subscription_id) do
      current_sub = Subscriptions.get_subscription_by_sub_id(sub.subscription_id)

      Subscriptions.update_subscription(current_sub, sub)
    else
      Subscriptions.create_subscription(sub)
    end
  end

  def get_invoices(customer_id) do
    {:ok, res} = Stripe.Invoice.list(%{customer: customer_id})

    Enum.each(res.data, fn invoice ->
      if invoice.status == "paid" do
        unless Transactions.invoice_exists(invoice.id) do
          item = List.first(invoice.lines.data)

          Transactions.create_transaction(%{
            invoice_id: invoice.id,
            status: invoice.status,
            amount_paid: invoice.amount_paid,
            description: item.description,
            subscription_id: invoice.subscription,
            charge_id: invoice.charge,
            customer_id: invoice.customer,
            created: invoice.created,
            merchant: "stripe",
            reference_number: invoice.number
          })
        end
      end
    end)
  end

  def payment_intent(product, user) do
    {:ok, response} =
      Stripe.PaymentIntent.create(%{
        amount: product.unit_amount,
        currency: "usd",
        customer: user.customer_id,
        metadata: %{user_id: user.id, product: product.name}
      })

    response
  end

  # def admin_refund(transaction_id, admin) do
  #   transaction = Transactions.get!(transaction_id)
  #   {:ok, refund} = Stripe.Refund.create(%{charge: transaction.charge_id})

  #   if refund.status == "succeeded" do
  #     Transactions.update(transaction, %{
  #       refund_id: refund.id,
  #       refunded: true,
  #       refunded_by: admin
  #     })
  #   else
  #     {:error, "Stripe Error"}
  #   end
  # end

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
end
