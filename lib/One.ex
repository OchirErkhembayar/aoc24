defmodule One do
  def one(test \\ false),
    do:
      Aoc24.read_file_lines_ints(1, test)
      |> Enum.reduce({[], []}, fn [left, right], {lefts, rights} ->
        {[left | lefts], [right | rights]}
      end)
      |> then(fn {lefts, rights} ->
        Enum.zip(Enum.sort(lefts), Enum.sort(rights))
        |> Enum.reduce(0, fn {l, r}, total -> total + abs(l - r) end)
      end)

  def two(test \\ false),
    do:
      Aoc24.read_file_lines_ints(1, test)
      |> Enum.reduce({[], %{}}, fn [left, right], {lefts, freqs} ->
        freqs = Map.update(freqs, right, 1, &(&1 + 1))
        {[left | lefts], freqs}
      end)
      |> then(fn {lefts, freqs} ->
        lefts
        |> Enum.reduce(0, &(&2 + Map.get(freqs, &1, 0) * &1))
      end)
end
