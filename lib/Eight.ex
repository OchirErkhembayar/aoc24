defmodule Eight do
  def one(test \\ false) do
    map =
      Aoc24.char_map(8, test)
      |> Enum.map(fn {xy, c} -> {xy, {c, false}} end)
      |> Enum.into(%{})

    map
    |> Enum.reduce(map, fn {{x, y}, {c, anti}}, map ->
      if not anti and c != "." do
        map
        |> Enum.filter(fn {{x1, y1}, {c1, _}} ->
          x1 != x and y1 != y and c1 == c
        end)
        |> Enum.reduce(map, fn {{x1, y1}, _}, map ->
          {dx, dy} = {x - x1, y - y1}
          nx1 = x + dx
          ny1 = y + dy
          nx2 = x1 - dx
          ny2 = y1 - dy

          if(Map.has_key?(map, {nx1, ny1}),
            do: Map.update!(map, {nx1, ny1}, fn {c, _} -> {c, true} end),
            else: map
          )
          |> then(
            &if Map.has_key?(&1, {nx2, ny2}),
              do: Map.update!(&1, {nx2, ny2}, fn {c, _} -> {c, true} end),
              else: &1
          )
        end)
      else
        map
      end
    end)
    |> Enum.count(fn {_, {_, anti}} -> anti end)
  end

  def two(test \\ false) do
    map =
      Aoc24.char_map(8, test)
      |> Enum.map(fn {xy, c} -> {xy, {c, false}} end)
      |> Enum.into(%{})

    map
    |> Enum.reduce(map, fn {{x, y}, {c, anti}}, map ->
      if not anti and c != "." do
        map
        |> Enum.filter(fn {{x1, y1}, {c1, _}} ->
          x1 != x and y1 != y and c1 == c
        end)
        |> Enum.reduce(map, fn {{x1, y1}, _}, map ->
          {dx, dy} = {x - x1, y - y1}

          Map.update!(map, {x, y}, fn {c, _} -> {c, true} end)
          |> update_while_exists(x, y, dx, dy)
          |> update_while_exists(x1, y1, -dx, -dy)
        end)
      else
        map
      end
    end)
    |> Enum.count(fn {_, {_, anti}} -> anti end)
  end

  def update_while_exists(map, x, y, dx, dy) do
    {new_x, new_y} = {x + dx, y + dy}

    if Map.has_key?(map, {new_x, new_y}) do
      map = Map.update!(map, {new_x, new_y}, fn {c, _} -> {c, true} end)
      update_while_exists(map, new_x, new_y, dx, dy)
    else
      map
    end
  end
end
