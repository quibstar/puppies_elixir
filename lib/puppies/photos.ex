defmodule Puppies.Photos do
  @moduledoc """
  The Photos context.
  """

  import Ecto.Query, warn: false
  alias Puppies.Repo

  alias Puppies.{Photos.Photo, ImageUtilities}
  alias ExAws.S3

  @doc """
  Returns the list of photos.

  ## Examples

      iex> list_photos()
      [%Photo{}, ...]

  """
  def list_photos do
    Repo.all(Photo)
  end

  @doc """
  Gets a single photo.

  Raises `Ecto.NoResultsError` if the Photo does not exist.

  ## Examples

      iex> get_photo!(123)
      %Photo{}

      iex> get_photo!(456)
      ** (Ecto.NoResultsError)

  """
  def get_photo!(id), do: Repo.get!(Photo, id)

  @doc """
  Creates a photo.

  ## Examples

      iex> create_photo(%{field: value})
      {:ok, %Photo{}}

      iex> create_photo(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_photo(attrs \\ %{}) do
    %Photo{}
    |> Photo.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a photo.

  ## Examples

      iex> update_photo(photo, %{field: new_value})
      {:ok, %Photo{}}

      iex> update_photo(photo, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_photo(%Photo{} = photo, attrs) do
    photo
    |> Photo.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a photo.

  ## Examples

      iex> delete_photo(photo)
      {:ok, %Photo{}}

      iex> delete_photo(photo)
      {:error, %Ecto.Changeset{}}

  """
  def delete_photo(%Photo{} = photo) do
    Repo.delete(photo)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking photo changes.

  ## Examples

      iex> change_photo(photo)
      %Ecto.Changeset{data: %Photo{}}

  """
  def change_photo(%Photo{} = photo, attrs \\ %{}) do
    Photo.changeset(photo, attrs)
  end

  def rename_photo(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end

  def resize_image(photo) do
    dest = File.cwd!() <> "/priv/static/uploads/" <> photo.name

    case photo.is_profile_image do
      true ->
        ImageUtilities.resize_profile_image(dest)

      false ->
        ImageUtilities.resize_image(dest)
    end

    update_photo(photo, %{resized: true})
    photo
  end

  def upload_to_cloud(photo) do
    host = Application.get_env(:ex_aws, :s3)[:host]
    scheme = Application.get_env(:ex_aws, :s3)[:scheme]

    if photo != nil do
      {:ok, image_binary} = File.read(File.cwd!() <> "/priv/static/uploads/" <> photo.name)

      S3.put_object("images", photo.name, image_binary)
      |> ExAws.request!()

      update_photo(photo, %{
        url: "#{scheme}#{host}/images/#{photo.name}"
      })
    end
  end

  def resize_and_send_to_aws(photo) do
    Task.start(fn ->
      resize_image(photo)
      |> upload_to_cloud()
    end)
  end
end
