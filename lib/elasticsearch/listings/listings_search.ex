defmodule Puppies.ES.ListingsSearch do
  alias Puppies.{ES.Api}

  def query_builder(query) do
    # true or false values
    must = query_only_true(query)

    # breeds
    must =
      if is_nil(query["breeds"]) or query["breeds"] == [] do
        must
      else
        [query_breeds(query) | must]
      end

    # location
    must =
      if query["search_by"] == "state" do
        [query_state(query) | must]
      else
        [query_location(query) | must]
      end

    # Price
    must =
      if query["min_price"] == "-0" and query["min_price"] == "-0" do
        must
      else
        [query_price(query) | must]
      end

    # age
    must =
      if is_nil(query["dob"]) || query["dob"] == "-1" do
        must
      else
        [query_age(query) | must]
      end

    # sex
    must =
      if is_nil(query["sex"]) || query["sex"] == "both" do
        must
      else
        [%{term: %{sex: query["sex"]}} | must]
      end

    must =
      cond do
        query["bloodline"] == "purebred" ->
          [%{term: %{purebred: true}} | must]

        query["bloodline"] == "designer" ->
          [%{term: %{purebred: false}} | must]

        query["bloodline"] == "both" ->
          must

        true ->
          must
      end

    page = String.to_integer(Map.get(query, "page", "1"))
    size = String.to_integer(Map.get(query, "size", "60"))

    {:ok, results} = listing_query(must, (page - 1) * size, size, sort(query))
    {:ok, res} = Jason.decode(results)
    %{matches: res["hits"]["hits"], count: res["hits"]["total"]["value"]}
  end

  def query_breeds(query) do
    %{terms: %{breeds_slug: query["breeds"]}}
  end

  def query_only_true(query) do
    query = Map.drop(query, ["is_filtering"])

    Enum.reduce(query, [], fn item, acc ->
      {key, value} = item

      if value == "true" do
        map = Map.put(%{}, String.to_atom(key), true)
        [%{term: map} | acc]
      else
        acc
      end
    end)
  end

  def query_age(query) do
    %{
      range: %{
        dob: %{
          gte: "now-#{query["dob"]}d",
          lte: "now"
        }
      }
    }
  end

  def query_location(query) do
    %{
      geo_distance: %{
        distance: "#{query["distance"]}mi",
        location: %{
          lat: query["lat"],
          lon: query["lng"]
        }
      }
    }
  end

  def query_state(query) do
    state = String.downcase(query["state"])
    %{term: %{region_short_code: state}}
  end

  def query_price(query) do
    min_price = Map.get(query, "min_price", "-1")
    max_price = Map.get(query, "max_price", "-1")

    %{
      range: %{
        price: %{
          gte: price_to_int(min_price, 0),
          lte: price_to_int(max_price, 1_000_000)
        }
      }
    }
  end

  def price_to_int(price, default) do
    if price == "-1" do
      default
    else
      String.to_integer(price)
    end
  end

  def sort(query) do
    case query["order"] do
      "price_low_to_high" ->
        %{price: "asc"}

      "price_high_to_low" ->
        %{price: "desc"}

      "newest" ->
        %{updated_at: "desc"}
    end
  end

  def listing_query(must, page, size, sort) do
    body = %{
      sort: [
        sort
      ],
      from: page,
      size: size,
      query: %{
        bool: %{
          must: must
        }
      }
    }

    Api.post("/listings/_search", body)
  end

  ##################################
  # State                          #
  ##################################

  def query_state(state, page, size) do
    s =
      if String.length(state) > 2 do
        %{region_slug: state}
      else
        %{region_short_code: state}
      end

    body = %{
      sort: [
        %{updated_at: "desc"}
      ],
      from: page,
      size: size,
      query: %{
        bool: %{
          must: [
            %{term: s}
          ]
        }
      }
    }

    Api.post("/listings/_search", body)
  end

  def state(state, page, size) do
    page = String.to_integer(page)
    size = String.to_integer(size)
    {:ok, results} = query_state(state, (page - 1) * size, size)
    {:ok, res} = Jason.decode(results)
    %{matches: res["hits"]["hits"], count: res["hits"]["total"]["value"]}
  end

  ##################################
  # city State                          #
  ##################################

  def query_city_state(city, state, page, size) do
    s =
      if String.length(state) > 2 do
        %{region_slug: state}
      else
        %{region_short_code: state}
      end

    body = %{
      sort: [
        %{updated_at: "desc"}
      ],
      from: page,
      size: size,
      query: %{
        bool: %{
          must: [
            %{term: s},
            %{term: %{place_slug: city}}
          ]
        }
      }
    }

    Api.post("/listings/_search", body)
  end

  def city_state(city, state, page, size) do
    page = String.to_integer(page)
    size = String.to_integer(size)
    {:ok, results} = query_city_state(city, state, (page - 1) * size, size)
    {:ok, res} = Jason.decode(results)
    %{matches: res["hits"]["hits"], count: res["hits"]["total"]["value"]}
  end

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
