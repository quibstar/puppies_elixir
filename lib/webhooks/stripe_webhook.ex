defmodule PuppiesWeb.StripeWebhooksController do
  use PuppiesWeb, :controller

  alias Puppies.{Stripe, Verifications.ID, Accounts}

  def webhooks(%Plug.Conn{assigns: %{stripe_event: stripe_event}} = conn, _params) do
    case handle_webhook(stripe_event) do
      {:ok, _} ->
        handle_success(conn)

      {:error, error} ->
        handle_error(conn, error)

      _ ->
        handle_error(conn, "error")
    end
  end

  defp handle_success(conn) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "ok")
  end

  defp handle_error(conn, error) do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(422, error)
  end

  # subscriptions

  defp handle_webhook(%{type: "invoice.payment_succeeded"} = stripe_event) do
    Stripe.update_subscription_payment_method(stripe_event.data.object)
  end

  defp handle_webhook(%{type: "customer.subscription.updated"} = stripe_event) do
    Stripe.process_subscription(stripe_event.data.object)
  end

  defp handle_webhook(%{type: "charge.succeeded"} = stripe_event) do
    obj = stripe_event.data.object
    Transactions.check_and_save_stripe_charge(obj)
  end

  # Verification
  defp handle_webhook(%{type: "identity.verification_session.created"} = stripe_event) do
    # save or update verification record
    process_identity_webhook(stripe_event)
  end

  defp handle_webhook(%{type: "identity.verification_session.requires_input"} = stripe_event) do
    # update verification record
    process_identity_webhook(stripe_event)
  end

  defp handle_webhook(%{type: "identity.verification_session.processing"} = stripe_event) do
    # update verification record
    process_identity_webhook(stripe_event)
  end

  defp handle_webhook(%{type: "identity.verification_session.verified"} = stripe_event) do
    # update verification record
    {:ok, res} = process_identity_webhook(stripe_event)
    Accounts.update_reputation_level(res.user_id, %{reputation_level: 3})
  end

  # defp handle_webhook(%{type: "file.created"} = stripe_event) do
  #   # add file link
  # end

  def process_identity_webhook(stripe_event) do
    stripe_event
    |> ID.process_stripe_event()
    |> ID.create_or_update_verification()
  end

  # defp handle_webhook(%{type: "charge.failed"} = stripe_event) do
  #   IO.inspect("Charge Failed")
  # end

  # defp handle_webhook(%{type: "payment_intent.created"} = stripe_event) do
  #   # handle invoice created webhook
  #   IO.inspect("Payment Intent Created")
  #   IO.inspect(stripe_event)
  # end

  # defp handle_webhook(%{type: "payment_intent.payment_failed"} = stripe_event) do
  #   # handle invoice created webhook
  #   IO.inspect("Payment Intent Failed")
  #   IO.inspect(stripe_event)
  # end

  # defp handle_webhook(%{type: "payment_intent.succeeded"} = stripe_event) do
  #   # handle invoice payment_succeeded webhook
  #   IO.inspect("Payment Intent Succeeded")
  #   IO.inspect(stripe_event)
  # end
end
