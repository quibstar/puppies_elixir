defmodule Puppies.Blacklists do
  @moduledoc """
  The Blacklists context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.Blacklists.Domain
  alias Puppies.{Pagination, Utilities}

  def get_all_blacklisted_items(schema) do
    Repo.all(schema)
  end

  def get_blacklisted_items(schema, opt) do
    q = from(b in schema)

    blacklisted_items =
      limit_offset(q, opt.limit, Utilities.set_offset(opt.page, opt.limit))
      |> Repo.all()

    paginate =
      Repo.aggregate(
        q,
        :count,
        :id
      )

    pagination = Pagination.pagination(paginate, opt.page, opt.limit, opt.number_of_links)

    %{blacklisted_items: blacklisted_items, pagination: pagination}
  end

  def limit_offset(q, limit, offset) do
    limit = Utilities.convert_string_to_integer(limit)
    from([b] in q, limit: ^limit, offset: ^offset)
  end

  # def check_for_existence_of(schema, field, other_field) do
  #   Repo.exists?(
  #     from(s in schema,
  #       where: field(s, ^field) == ^other_field
  #     )
  #   )
  # end

  def get_domain_blacklist!(id) do
    Repo.get!(Domain, id)
  end

  @doc """
  Creates a domain_blacklist.

  ## Examples

      iex> create_domain_blacklist(%{field: value})
      {:ok, %Domain{}}

      iex> create_domain_blacklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_domain_blacklist(attrs \\ %{}) do
    %Domain{}
    |> Domain.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a domain_blacklist.

  ## Examples

      iex> delete_domain_blacklist(domain_blacklist)
      {:ok, %Domain{}}

      iex> delete_domain_blacklist(domain_blacklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_domain_blacklist(%Domain{} = domain_blacklist) do
    Repo.delete(domain_blacklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking domain_blacklist changes.

  ## Examples

      iex> change_domain_blacklist(domain_blacklist)
      %Ecto.Changeset{data: %Domain{}}

  """
  def change_domain_blacklist(%Domain{} = domain_blacklist, attrs \\ %{}) do
    Domain.changeset(domain_blacklist, attrs)
  end

  def domain_in_excluded_list(domain) do
    Repo.exists?(
      from(f in Domain,
        where: f.domain == ^domain
      )
    )
  end

  alias Puppies.Blacklists.IPAddress

  def get_ip_address_blacklist!(id) do
    Repo.get!(IPAddress, id)
  end

  @doc """
  Creates a ip_address_blacklist.

  ## Examples

      iex> create_ip_address_blacklist(%{field: value})
      {:ok, %IPAddress{}}

      iex> create_ip_address_blacklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ip_address_blacklist(attrs \\ %{}) do
    %IPAddress{}
    |> IPAddress.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a ip_address_blacklist.

  ## Examples

      iex> delete_ip_address_blacklist(ip_address_blacklist)
      {:ok, %IPAddress{}}

      iex> delete_ip_address_blacklist(ip_address_blacklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ip_address_blacklist(%IPAddress{} = ip_address_blacklist) do
    Repo.delete(ip_address_blacklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ip_address_blacklist changes.

  ## Examples

      iex> change_ip_address_blacklist(ip_address_blacklist)
      %Ecto.Changeset{data: %IPAddress{}}

  """
  def change_ip_address_blacklist(%IPAddress{} = ip_address_blacklist, attrs \\ %{}) do
    IPAddress.changeset(ip_address_blacklist, attrs)
  end

  alias Puppies.Blacklists.Content

  def get_content_blacklist!(id) do
    Repo.get!(Content, id)
  end

  @doc """
  Creates a content_blacklist.

  ## Examples

      iex> create_content_blacklist(%{field: value})
      {:ok, %Content{}}

      iex> create_content_blacklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_content_blacklist(attrs \\ %{}) do
    %Content{}
    |> Content.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a content_blacklist.

  ## Examples

      iex> delete_content_blacklist(content_blacklist)
      {:ok, %Content{}}

      iex> delete_content_blacklist(content_blacklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_content_blacklist(%Content{} = content_blacklist) do
    Repo.delete(content_blacklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking content_blacklist changes.

  ## Examples

      iex> change_content_blacklist(content_blacklist)
      %Ecto.Changeset{data: %Content{}}

  """
  def change_content_blacklist(%Content{} = content_blacklist, attrs \\ %{}) do
    Content.changeset(content_blacklist, attrs)
  end

  alias Puppies.Blacklists.Phone

  def get_phone_blacklist!(id) do
    Repo.get!(Phone, id)
  end

  @doc """
  Creates a phone_blacklist.

  ## Examples

      iex> create_phone_blacklist(%{field: value})
      {:ok, %Phone{}}

      iex> create_phone_blacklist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_phone_blacklist(attrs \\ %{}) do
    %Phone{}
    |> Phone.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a phone_blacklist.

  ## Examples

      iex> delete_phone_blacklist(phone_blacklist)
      {:ok, %Phone{}}

      iex> delete_phone_blacklist(phone_blacklist)
      {:error, %Ecto.Changeset{}}

  """
  def delete_phone_blacklist(%Phone{} = phone_blacklist) do
    Repo.delete(phone_blacklist)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking phone_blacklist changes.

  ## Examples

      iex> change_phone_blacklist(phone_blacklist)
      %Ecto.Changeset{data: %Phone{}}

  """
  def change_phone_blacklist(%Phone{} = phone_blacklist, attrs \\ %{}) do
    Phone.changeset(phone_blacklist, attrs)
  end

  alias Puppies.Blacklists.Country

  def get_country(id) do
    Country
    |> Repo.get(id)
  end

  def get_country_blacklist() do
    Repo.all(from(c in Country, order_by: c.name))
  end

  def update_blacklisted_country(country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  def create_country_blacklist(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  def get_selected_blacklisted_countries() do
    Repo.all(
      from(c in Country,
        where: c.selected == true,
        order_by: c.name
      )
    )
  end
end
