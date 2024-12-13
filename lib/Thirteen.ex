defmodule Thirteen do
  def one(test \\ false), do: run(test, false)

  def two(test \\ false), do: run(test, true)

  def run(test, part_two),
    do:
      String.split(Aoc24.read_file(13, test), "\n\n", trim: true)
      |> Enum.reduce(0, fn s, acc ->
        [xa, ya, xb, yb, xp, yp] =
          String.split(s, "\n", trim: true)
          |> Enum.flat_map(fn line ->
            String.split(line, [": ", ", "])
            |> Enum.drop(1)
            |> Enum.map(&(String.split_at(&1, 2) |> then(fn {_, n} -> String.to_integer(n) end)))
          end)

        xp =
          if part_two,
            do: xp + 10_000_000_000_000,
            else: xp

        yp =
          if part_two,
            do: yp + 10_000_000_000_000,
            else: yp

        b = (yp * xa - ya * xp) / (yb * xa - ya * xb)
        a = (xp - b * xb) / xa
        acc + if b == floor(b) and a == floor(a), do: floor(a) * 3 + floor(b), else: 0
      end)
end
