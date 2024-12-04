defmodule Four do
  def one(test \\ false) do
    map = Aoc24.char_map(4, test)

    map
    |> Enum.reduce(0, fn {{x, y}, c}, sum ->
      if c != "X" do
        sum
      else
        hori =
          substr(map, c, [{x - 3, y}, {x - 2, y}, {x - 1, y}], [
            {x + 1, y},
            {x + 2, y},
            {x + 3, y}
          ])

        vert =
          substr(map, c, [{x, y + 3}, {x, y + 2}, {x, y + 1}], [
            {x, y - 1},
            {x, y - 2},
            {x, y - 3}
          ])

        d1 =
          substr(map, c, [{x + 3, y + 3}, {x + 2, y + 2}, {x + 1, y + 1}], [
            {x - 1, y - 1},
            {x - 2, y - 2},
            {x - 3, y - 3}
          ])

        d2 =
          substr(map, c, [{x - 3, y + 3}, {x - 2, y + 2}, {x - 1, y + 1}], [
            {x + 1, y - 1},
            {x + 2, y - 2},
            {x + 3, y - 3}
          ])

        [hori, vert, d1, d2]
        |> Enum.reduce(sum, fn s, acc ->
          acc +
            case String.split_at(s, 4) do
              {"SAMX", "MAS"} -> 2
              {"SAMX", _} -> 1
              {_, "MAS"} -> 1
              _ -> 0
            end
        end)
      end
    end)
  end

  def two(test \\ false) do
    map = Aoc24.char_map(4, test)

    map
    |> Enum.reduce(0, fn {{x, y}, c}, sum ->
      if c != "A" do
        sum
      else
        d1 = substr(map, "A", [{x + 1, y + 1}], [{x - 1, y - 1}])
        d2 = substr(map, "A", [{x - 1, y + 1}], [{x + 1, y - 1}])

        if String.match?(d1, ~r/MAS|SAM/) and
             String.match?(d2, ~r/MAS|SAM/),
           do: sum + 1,
           else: sum
      end
    end)
  end

  defp substr(map, mid, back_coords, fwd_coords) do
    Enum.reduce(back_coords, "", fn coords, acc -> acc <> Map.get(map, coords, "N") end) <>
      mid <> Enum.reduce(fwd_coords, "", fn coords, acc -> acc <> Map.get(map, coords, "N") end)
  end
end
