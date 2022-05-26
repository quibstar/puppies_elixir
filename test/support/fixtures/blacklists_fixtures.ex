defmodule Puppies.BlacklistsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Puppies.Blacklists` context.
  """

  @doc """
  Generate a domain_blacklist.
  """
  def domain_blacklist_fixture(attrs \\ %{}) do
    {:ok, domain_blacklist} =
      attrs
      |> Enum.into(%{
        domain: "some domain"
      })
      |> Puppies.Blacklists.create_domain_blacklist()

    domain_blacklist
  end

  @doc """
  Generate a ip_address_blacklist.
  """
  def ip_address_blacklist_fixture(attrs \\ %{}) do
    {:ok, ip_address_blacklist} =
      attrs
      |> Enum.into(%{
        ip_address: "some ip_address"
      })
      |> Puppies.Blacklists.create_ip_address_blacklist()

    ip_address_blacklist
  end

  @doc """
  Generate a content_blacklist.
  """
  def content_blacklist_fixture(attrs \\ %{}) do
    {:ok, content_blacklist} =
      attrs
      |> Enum.into(%{
        content: "some content"
      })
      |> Puppies.Blacklists.create_content_blacklist()

    content_blacklist
  end

  @doc """
  Generate a phone_blacklist.
  """
  def phone_blacklist_fixture(attrs \\ %{}) do
    {:ok, phone_blacklist} =
      attrs
      |> Enum.into(%{
        phone_number: "6164444444"
      })
      |> Puppies.Blacklists.create_phone_blacklist()

    phone_blacklist
  end
end
