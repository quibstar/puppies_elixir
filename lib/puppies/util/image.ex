defmodule Puppies.ImageUtilities do
  @moduledoc """
  Resizing images
  """
  import Mogrify

  def resize_image(image_path) do
    open(image_path)
    |> resize_to_fill("800x800")
    |> gravity("Center")
    |> quality(75)
    |> save(in_place: true)
  end

  def resize_profile_image(image_path) do
    open(image_path)
    |> gravity("Center")
    |> resize_to_fill("200x300")
    |> save(in_place: true)
  end
end
