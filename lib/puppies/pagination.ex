defmodule Puppies.Pagination do
  @moduledoc """
  Pagination
  """
  def pagination(count, page, limit, number_of_links \\ 7) do
    page = String.to_integer(page)
    limit = String.to_integer(limit)
    previous = page - 1
    next = page + 1
    last_page = (count / limit) |> ceil()

    map1 = %{
      count: count,
      last_page: last_page,
      previous: previous,
      next: next,
      page: page,
      limit: limit
    }

    number_of_links =
      if last_page > number_of_links do
        number_of_links
      else
        last_page
      end

    map2 = last_link(page, number_of_links, last_page, number_of_links)
    m = Map.merge(map1, map2)
    m
  end

  defp last_link(page, number_of_links, last_page, number_of_links) do
    page_plus_links = page + number_of_links

    # example
    # %{
    #   count: 1919,
    #   first_link: 79,
    #   last_link: 80,
    #   last_page: 80,
    #   next: 71,
    #   previous: 69
    # }

    first_link =
      if last_page - number_of_links <= 0 do
        1
      else
        last_page - number_of_links
      end

    cond do
      page < number_of_links ->
        %{first_link: 1, last_link: number_of_links}

      page >= number_of_links && page <= last_page - number_of_links ->
        %{first_link: page - 3, last_link: page_plus_links - 3}

      page_plus_links >= last_page ->
        %{first_link: first_link, last_link: last_page}

      true ->
        %{first_link: 1, last_link: number_of_links}
    end
  end
end
