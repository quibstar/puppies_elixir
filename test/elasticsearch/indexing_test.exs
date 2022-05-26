defmodule Puppies.ElatsticsearchTest do
  use Puppies.DataCase

  alias Puppies.ES.ListingFixture
  alias Puppies.{ES.Indexing, Mappings, ES.Api}

  @listing "listing_test"

  setup do
    {:ok, list} = Indexing.get_index("_aliases")
    new_list = Jason.decode!(list)

    Enum.each(new_list, fn l ->
      res = elem(l, 0)

      if String.contains?(res, "listing") do
        Indexing.delete_index(res)
      end
    end)

    :ok
  end

  describe "Elasticsearch" do
    test "get health" do
      {:ok, health} = Indexing.health()
      res = Jason.decode!(health)
      status = Map.get(res, "status")
      assert(status, "yellow")
    end

    test "create index" do
      Indexing.create_index(@listing)
      {:ok, idx} = Indexing.get_index(@listing)

      res = Jason.decode!(idx)
      assert(res[@listing] != %{})
    end

    test "post data" do
      Indexing.create_index(@listing)

      Api.post("/#{@listing}/_doc/1", ListingFixture.es_listing(%{price: 2500}))
      {:ok, res} = Api.get("/#{@listing}/_doc/1")

      listing = Jason.decode!(res)
      price = Map.get(listing, "_source") |> Map.get("price")
      assert(price == 2500)

      test = Api.post("/#{@listing}/_update/1", %{doc: %{price: 500}})

      {:ok, res} = Api.get("/#{@listing}/_doc/1")

      listing = Jason.decode!(res)

      price = Map.get(listing, "_source") |> Map.get("price")
      assert(price == 500)
    end
  end

  def create_list_mappings() do
    listing_mapping = Mappings.listings()
    {:ok, idx} = Indexing.create_mappings(@listing, listing_mapping)
  end
end
