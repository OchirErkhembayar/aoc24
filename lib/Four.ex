defmodule Four do
  def one(test \\ false),
    do:
      Aoc24.char_map(4, test)
      |> then(
        &(&1
          |> Enum.filter(fn {_, c} -> c == "X" end)
          |> Enum.reduce(0, fn {{x, y}, c}, sum ->
            [
              substr(&1, c, [{x - 3, y}, {x - 2, y}, {x - 1, y}], [
                {x + 1, y},
                {x + 2, y},
                {x + 3, y}
              ]),
              substr(&1, c, [{x, y + 3}, {x, y + 2}, {x, y + 1}], [
                {x, y - 1},
                {x, y - 2},
                {x, y - 3}
              ]),
              substr(&1, c, [{x + 3, y + 3}, {x + 2, y + 2}, {x + 1, y + 1}], [
                {x - 1, y - 1},
                {x - 2, y - 2},
                {x - 3, y - 3}
              ]),
              substr(&1, c, [{x - 3, y + 3}, {x - 2, y + 2}, {x - 1, y + 1}], [
                {x + 1, y - 1},
                {x + 2, y - 2},
                {x + 3, y - 3}
              ])
            ]
            |> Enum.reduce(sum, fn s, acc ->
              acc +
                case String.split_at(s, 4) do
                  {"SAMX", "MAS"} -> 2
                  {"SAMX", _} -> 1
                  {_, "MAS"} -> 1
                  _ -> 0
                end
            end)
          end))
      )

  def two(test \\ false),
    do:
      Aoc24.char_map(4, test)
      |> then(
        &(&1
          |> Enum.filter(fn {_, c} -> c == "A" end)
          |> Enum.reduce(0, fn {{x, y}, c}, sum ->
            if String.match?(substr(&1, c, [{x + 1, y + 1}], [{x - 1, y - 1}]), ~r/MAS|SAM/) and
                 String.match?(substr(&1, c, [{x - 1, y + 1}], [{x + 1, y - 1}]), ~r/MAS|SAM/),
               do: sum + 1,
               else: sum
          end))
      )

  defp substr(map, mid, back_coords, fwd_coords),
    do:
      Enum.reduce(back_coords, "", &(&2 <> Map.get(map, &1, "N"))) <>
        mid <> Enum.reduce(fwd_coords, "", &(&2 <> Map.get(map, &1, "N")))
end
