defmodule Puppies.ListingSearchTest do
  use Puppies.DataCase

  alias Puppies.ES.ListingFixture
  alias Puppies.{ES.ListingsSearch}

  # setup do

  #   :ok
  # end

  describe "Elasticsearch" do
    test "search by state" do
      res = ListingsSearch.query_state(%{"state" => "MI"})
      assert(res == %{term: %{region_short_code: "mi"}})
    end

    test "search by breeds" do
      res = ListingsSearch.query_breeds(%{"breeds" => ["german-shorthaired-pointer", "shih-poo"]})
      assert(res == %{terms: %{breeds_slug: ["german-shorthaired-pointer", "shih-poo"]}})
    end

    test "gets all true" do
      res = ListingsSearch.query_only_true(example)
      assert(res == [%{term: %{purebred: true}}])
    end

    test "get by age" do
      res = ListingsSearch.query_age(%{"dob" => "7"})
      assert(res == %{range: %{dob: %{gte: "now-7d", lte: "now"}}})
      res = ListingsSearch.query_age(%{"dob" => "180"})
      assert(res == %{range: %{dob: %{gte: "now-180d", lte: "now"}}})
    end

    test "get by price" do
      res = ListingsSearch.query_price(%{"min_price" => "200", "max_price" => "2000"})
      assert(res == %{range: %{price: %{gte: 200, lte: 2000}}})
      res = ListingsSearch.query_price(%{"min_price" => "200", "max_price" => "-1"})
      assert(res == %{range: %{price: %{gte: 200, lte: 1_000_000}}})
    end

    test "get by location" do
      res =
        ListingsSearch.query_location(%{
          "distance" => "100",
          "lat" => "42.9632",
          "lng" => "-85.6679"
        })

      assert(
        res == %{geo_distance: %{location: %{lat: "42.9632", lon: "-85.6679"}, distance: "100mi"}}
      )
    end

    test "query builder" do
      res = ListingsSearch.query_builder(example)
    end
  end

  def example do
    %{
      "breed" => "",
      "breeds" => ["german-shorthaired-pointer", "shih-poo"],
      "champion_bloodline" => "false",
      "champion_sired" => "false",
      "current_vaccinations" => "false",
      "designer" => "false",
      "distance" => "15",
      "dob" => "-1",
      "health_certificate" => "false",
      "health_guarantee" => "false",
      "hypoallergenic" => "false",
      "is_filtering" => "false",
      "limit" => "60",
      "lat" => "42.9632",
      "lng" => "-85.6679",
      "sex" => "male",
      "max_price" => "2000",
      "microchip" => "false",
      "min_price" => "100",
      "order" => "price_low_to_high",
      "page" => "2",
      "pedigree" => "false",
      "place_id" => "place.9300664570886750",
      "place_name" => "Grand Rapids, Michigan, United States",
      "purebred" => "true",
      "purebred_and_designer" => "false",
      "registered" => "false",
      "registrable" => "false",
      "search_by" => "location",
      "show_quality" => "false",
      "veterinary_exam" => "false"
    }
  end
end
