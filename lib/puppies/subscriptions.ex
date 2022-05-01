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
end
