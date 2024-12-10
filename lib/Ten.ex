defmodule Ten do
  defp data(test) do
    Aoc24.char_map(10, test)
    |> Enum.map(fn {c, n} -> {c, String.to_integer(n)} end)
    |> Enum.into(%{})
  end

  def one(test \\ false),
    do:
      data(test)
      |> then(
        &(&1
          |> Enum.reduce(0, fn {{y, x}, start}, acc ->
            if start == 0,
              do: (get_score(&1, {y, x}, 1, false) |> Enum.uniq() |> Enum.count()) + acc,
              else: acc
          end))
      )

  def two(test \\ false),
    do:
      data(test)
      |> then(
        &(&1
          |> Enum.reduce(0, fn {{y, x}, start}, acc ->
            if start == 0, do: get_score(&1, {y, x}, 1, true) + acc, else: acc
          end))
      )

  def get_score(_, coords, 10, part_two), do: if(part_two, do: 1, else: [coords])

  def get_score(map, {y, x}, next, part_two),
    do:
      [{y + 1, x}, {y - 1, x}, {y, x + 1}, {y, x - 1}]
      |> Enum.reduce(if(part_two, do: 0, else: []), fn coords, accs ->
        if Map.get(map, coords) == next,
          do:
            if(part_two,
              do: get_score(map, coords, next + 1, part_two) + accs,
              else: get_score(map, coords, next + 1, part_two) ++ accs
            ),
          else: accs
      end)
end
