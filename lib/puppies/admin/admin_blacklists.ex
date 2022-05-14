defmodule Puppies.Blacklists do
  @moduledoc """
  The Blacklists context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Blacklists.EmailBlacklist

  def get_blacklisted_items(schema) do
    Repo.all(schema)
  end

  def check_for_existence_of(schema, field, other_field) do
    Repo.exists?(
      from(s in schema,
        where: field(s, ^field) == ^other_field
      )
    )
  end

  @doc """
  Creates a email_blacklist.

  ## Examples

      iex> create_email_blacklist(%{field: value})
      {:ok, %EmailBlacklist{}}

      iex> create_email_blacklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_email_blacklist(attrs \\ %{}) do
    %EmailBlacklist{}
    |> EmailBlacklist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a email_blacklist.

  ## Examples

      iex> delete_email_blacklist(email_blacklist)
      {:ok, %EmailBlacklist{}}

      iex> delete_email_blacklist(email_blacklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_email_blacklist(%EmailBlacklist{} = email_blacklist) do
    Repo.delete(email_blacklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking email_blacklist changes.

  ## Examples

      iex> change_email_blacklist(email_blacklist)
      %Ecto.Changeset{data: %EmailBlacklist{}}

  """
  def change_email_blacklist(%EmailBlacklist{} = email_blacklist, attrs \\ %{}) do
    EmailBlacklist.changeset(email_blacklist, attrs)
  end

  alias Puppies.Blacklists.IPAddressBlacklist

  @doc """
  Creates a ip_address_blacklist.

  ## Examples

      iex> create_ip_address_blacklist(%{field: value})
      {:ok, %IPAddressBlacklist{}}

      iex> create_ip_address_blacklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ip_address_blacklist(attrs \\ %{}) do
    %IPAddressBlacklist{}
    |> IPAddressBlacklist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a ip_address_blacklist.

  ## Examples

      iex> delete_ip_address_blacklist(ip_address_blacklist)
      {:ok, %IPAddressBlacklist{}}

      iex> delete_ip_address_blacklist(ip_address_blacklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ip_address_blacklist(%IPAddressBlacklist{} = ip_address_blacklist) do
    Repo.delete(ip_address_blacklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ip_address_blacklist changes.

  ## Examples

      iex> change_ip_address_blacklist(ip_address_blacklist)
      %Ecto.Changeset{data: %IPAddressBlacklist{}}

  """
  def change_ip_address_blacklist(%IPAddressBlacklist{} = ip_address_blacklist, attrs \\ %{}) do
    IPAddressBlacklist.changeset(ip_address_blacklist, attrs)
  end

  alias Puppies.Blacklists.ContentBlacklist

  @doc """
  Creates a content_blacklist.

  ## Examples

      iex> create_content_blacklist(%{field: value})
      {:ok, %ContentBlacklist{}}

      iex> create_content_blacklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_content_blacklist(attrs \\ %{}) do
    %ContentBlacklist{}
    |> ContentBlacklist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a content_blacklist.

  ## Examples

      iex> delete_content_blacklist(content_blacklist)
      {:ok, %ContentBlacklist{}}

      iex> delete_content_blacklist(content_blacklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_content_blacklist(%ContentBlacklist{} = content_blacklist) do
    Repo.delete(content_blacklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking content_blacklist changes.

  ## Examples

      iex> change_content_blacklist(content_blacklist)
      %Ecto.Changeset{data: %ContentBlacklist{}}

  """
  def change_content_blacklist(%ContentBlacklist{} = content_blacklist, attrs \\ %{}) do
    ContentBlacklist.changeset(content_blacklist, attrs)
  end

  alias Puppies.Blacklists.PhoneBlacklist

  @doc """
  Creates a phone_blacklist.

  ## Examples

      iex> create_phone_blacklist(%{field: value})
      {:ok, %PhoneBlacklist{}}

      iex> create_phone_blacklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_phone_blacklist(attrs \\ %{}) do
    %PhoneBlacklist{}
    |> PhoneBlacklist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a phone_blacklist.

  ## Examples

      iex> delete_phone_blacklist(phone_blacklist)
      {:ok, %PhoneBlacklist{}}

      iex> delete_phone_blacklist(phone_blacklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_phone_blacklist(%PhoneBlacklist{} = phone_blacklist) do
    Repo.delete(phone_blacklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking phone_blacklist changes.

  ## Examples

      iex> change_phone_blacklist(phone_blacklist)
      %Ecto.Changeset{data: %PhoneBlacklist{}}

  """
  def change_phone_blacklist(%PhoneBlacklist{} = phone_blacklist, attrs \\ %{}) do
    PhoneBlacklist.changeset(phone_blacklist, attrs)
  end
end
