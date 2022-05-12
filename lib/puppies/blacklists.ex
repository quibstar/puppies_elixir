defmodule Puppies.Blacklists do
  @moduledoc """
  The Blacklists context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Blacklists.EmailBlacklist

  @doc """
  Returns the list of email_blacklists.

  ## Examples

      iex> list_email_blacklists()
      [%EmailBlacklist{}, ...]

  """
  def list_email_blacklists do
    Repo.all(EmailBlacklist)
  end

  @doc """
  Gets a single email_blacklist.

  Raises `Ecto.NoResultsError` if the Email blacklist does not exist.

  ## Examples

      iex> get_email_blacklist!(123)
      %EmailBlacklist{}

      iex> get_email_blacklist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_email_blacklist!(id), do: Repo.get!(EmailBlacklist, id)

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
  Updates a email_blacklist.

  ## Examples

      iex> update_email_blacklist(email_blacklist, %{field: new_value})
      {:ok, %EmailBlacklist{}}

      iex> update_email_blacklist(email_blacklist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_email_blacklist(%EmailBlacklist{} = email_blacklist, attrs) do
    email_blacklist
    |> EmailBlacklist.changeset(attrs)
    |> Repo.update()
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
  Returns the list of ip_address_blacklists.

  ## Examples

      iex> list_ip_address_blacklists()
      [%IPAddressBlacklist{}, ...]

  """
  def list_ip_address_blacklists do
    Repo.all(IPAddressBlacklist)
  end

  @doc """
  Gets a single ip_address_blacklist.

  Raises `Ecto.NoResultsError` if the Ip address blacklist does not exist.

  ## Examples

      iex> get_ip_address_blacklist!(123)
      %IPAddressBlacklist{}

      iex> get_ip_address_blacklist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ip_address_blacklist!(id), do: Repo.get!(IPAddressBlacklist, id)

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
  Updates a ip_address_blacklist.

  ## Examples

      iex> update_ip_address_blacklist(ip_address_blacklist, %{field: new_value})
      {:ok, %IPAddressBlacklist{}}

      iex> update_ip_address_blacklist(ip_address_blacklist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ip_address_blacklist(%IPAddressBlacklist{} = ip_address_blacklist, attrs) do
    ip_address_blacklist
    |> IPAddressBlacklist.changeset(attrs)
    |> Repo.update()
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
  Returns the list of content_blacklists.

  ## Examples

      iex> list_content_blacklists()
      [%ContentBlacklist{}, ...]

  """
  def list_content_blacklists do
    Repo.all(ContentBlacklist)
  end

  @doc """
  Gets a single content_blacklist.

  Raises `Ecto.NoResultsError` if the Content blacklist does not exist.

  ## Examples

      iex> get_content_blacklist!(123)
      %ContentBlacklist{}

      iex> get_content_blacklist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_content_blacklist!(id), do: Repo.get!(ContentBlacklist, id)

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
  Updates a content_blacklist.

  ## Examples

      iex> update_content_blacklist(content_blacklist, %{field: new_value})
      {:ok, %ContentBlacklist{}}

      iex> update_content_blacklist(content_blacklist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_content_blacklist(%ContentBlacklist{} = content_blacklist, attrs) do
    content_blacklist
    |> ContentBlacklist.changeset(attrs)
    |> Repo.update()
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

  def check_for_content(%{"content" => content}) do
    Repo.exists?(
      from(c in ContentBlacklist,
        where: c.content == ^content
      )
    )
  end

  alias Puppies.Blacklists.PhoneBlacklist

  @doc """
  Returns the list of phone_blacklists.

  ## Examples

      iex> list_phone_blacklists()
      [%PhoneBlacklist{}, ...]

  """
  def list_phone_blacklists do
    Repo.all(PhoneBlacklist)
  end

  @doc """
  Gets a single phone_blacklist.

  Raises `Ecto.NoResultsError` if the Phone blacklist does not exist.

  ## Examples

      iex> get_phone_blacklist!(123)
      %PhoneBlacklist{}

      iex> get_phone_blacklist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_phone_blacklist!(id), do: Repo.get!(PhoneBlacklist, id)

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
  Updates a phone_blacklist.

  ## Examples

      iex> update_phone_blacklist(phone_blacklist, %{field: new_value})
      {:ok, %PhoneBlacklist{}}

      iex> update_phone_blacklist(phone_blacklist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_phone_blacklist(%PhoneBlacklist{} = phone_blacklist, attrs) do
    phone_blacklist
    |> PhoneBlacklist.changeset(attrs)
    |> Repo.update()
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
