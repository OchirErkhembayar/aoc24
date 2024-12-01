defmodule One do
  def one(test \\ false),
    do:
      data(test)
      |> Enum.reduce({[], []}, fn {left, right}, {lefts, rights} ->
        {[left | lefts], [right | rights]}
      end)
      |> then(fn {lefts, rights} ->
        Enum.zip(Enum.sort(lefts), Enum.sort(rights))
        |> Enum.map(fn {l, r} -> abs(l - r) end)
        |> Enum.sum()
      end)

  def two(test \\ false),
    do:
      data(test)
      |> Enum.reduce({[], %{}}, fn {left, right}, {lefts, freqs} ->
        freqs = Map.update(freqs, right, 1, &(&1 + 1))
        {[left | lefts], freqs}
      end)
      |> then(fn {lefts, freqs} ->
        lefts
        |> Enum.reduce(0, &(&2 + Map.get(freqs, &1, 0) * &1))
      end)

  defp data(test),
    do:
      Aoc24.read_file_lines_words(1, test)
      |> Enum.map(fn [left, right] -> {String.to_integer(left), String.to_integer(right)} end)
end
