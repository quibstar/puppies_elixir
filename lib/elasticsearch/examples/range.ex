# defmodule Puppies.ES.BreedSearch do
#   alias Puppies.{ES.Api}

#   def autocomplete(term) do
#     {:ok, results} =
#       if Map.has_key?(term, "name") do
#         query_breeds_by_name(term)
#       else
#         query_breeds_by_attributes(term)
#       end

#     {:ok, res} = Jason.decode(results)

#     res = res["hits"]["hits"]

#     unless res == [] do
#       process_hits(res)
#     end
#   end

#   defp query_breeds_by_name(term) do
#     q = %{
#       size: 400,
#       query: %{
#         match_bool_prefix: %{
#           name: term["name"]
#         }
#       }
#     }

#     Api.post("/breeds/_search", q)
#   end

#   defp query_breeds_by_attributes(term) do
#     q = %{
#       size: 400,
#       query: %{
#         bool: %{
#           must: [
#             %{range: %{size: %{gte: term["size_min"], lte: term["size_max"]}}},
#             %{range: %{kid_friendly: term_range(term["kid_friendly"])}},
#             %{range: %{dog_friendly: term_range(term["dog_friendly"])}},
#             %{range: %{amount_of_shedding: term_range(term["amount_of_shedding"])}},
#             %{range: %{intelligence: term_range(term["intelligence"])}},
#             %{range: %{intensity: term_range(term["intensity"])}},
#             %{range: %{tendency_to_bark_or_howl: term_range(term["tendency_to_bark_or_howl"])}},
#             %{range: %{trainability: term_range(term["trainability"])}}
#           ]
#         }
#       }
#     }

#     Api.post("/breeds/_search", q)
#   end

#   def term_range(term) do
#     term = String.to_integer(term)

#     %{
#       gte: term - 1,
#       lte: term + 1
#     }
#   end

#   defp process_hits(data) do
#     res =
#       Enum.reduce(data, [], fn d, acc ->
#         map = %{
#           name: d["_source"]["name"],
#           slug: d["_source"]["slug"],
#           size: d["_source"]["size"],
#           kid_friendly: d["_source"]["kid_friendly"],
#           amount_of_shedding: d["_source"]["amount_of_shedding"],
#           dog_friendly: d["_source"]["dog_friendly"],
#           intelligence: d["_source"]["intelligence"],
#           intensity: d["_source"]["intensity"],
#           tendency_to_bark_or_howl: d["_source"]["tendency_to_bark_or_howl"],
#           trainability: d["_source"]["trainability"],
#           score: d["_score"]
#         }

#         [map | acc]
#       end)

#     Enum.reverse(res)
#   end
# end
