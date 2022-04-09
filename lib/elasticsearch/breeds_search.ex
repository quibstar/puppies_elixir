defmodule Puppies.ES.BreedsSearch do
  alias Puppies.{ES.Api}

  def popular_breeds_aggregate() do
    body = %{
      size: 0,
      aggs: %{
        breeds: %{
          terms: %{
            field: "breeds_slug"
          }
        }
      }
    }

    Api.post("/listings/_search", body)
  end
end
