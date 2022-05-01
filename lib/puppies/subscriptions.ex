defmodule Puppies.Subscriptions do
  @moduledoc """
  Subscriptions module
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo
  alias Puppies.Subscription

  def get_subscription_by_sub_id(subscription_id) do
    from(p in Subscription,
      where: p.subscription_id == ^subscription_id
    )
    |> Repo.one()
  end

  def get_user_subscriptions(customer_id) do
    from(s in Subscription,
      where: s.customer_id == ^customer_id
    )
    |> Repo.all()
  end

  def user_subscription_count(customer_id) do
    from(s in Subscription,
      where: s.customer_id == ^customer_id,
      select: count(s.id)
    )
    |> Repo.one()
  end

  def get_user_active_subscriptions(customer_id) do
    from(s in Subscription,
      where: s.customer_id == ^customer_id and s.subscription_status == "active",
      preload: :product
    )
    |> Repo.all()
  end

  def create_subscription(attrs \\ %{}) do
    %Subscription{}
    |> Subscription.changeset(attrs)
    |> Repo.insert()
  end

  def update_subscription(%Subscription{} = subscription, attrs) do
    subscription
    |> Subscription.changeset(attrs)
    |> Repo.update()
  end

  def subscription_exists(sub_id) do
    Repo.exists?(
      from(s in Subscription,
        where: s.subscription_id == ^sub_id
      )
    )
  end

  def create_or_save_subscription(data_object) do
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

    if subscription_exists(sub.subscription_id) do
      current_sub = get_subscription_by_sub_id(sub.subscription_id)

      update_subscription(current_sub, sub)
    else
      create_subscription(sub)
    end
  end
end
