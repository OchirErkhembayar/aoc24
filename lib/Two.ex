defmodule Two do
  def one(test \\ false) do
    Aoc24.read_file_lines_ints(2, test)
    |> Enum.count(&valid(&1))
  end

  def two(test \\ false) do
    Aoc24.read_file_lines_ints(2, test)
    |> Enum.count(fn report ->
      valid(report) or
        0..(length(report) - 1)
        |> Enum.any?(fn i ->
          valid(List.delete_at(report, i))
        end)
    end)
  end

  defp valid([fst, snd | _]) when fst == snd, do: false

  defp valid([one, two| _] = report) do
    report
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [fst, snd] ->
      diff = abs(fst - snd)
      diff >= 1 and diff <= 3 and if two > one, do: snd > fst, else: fst > snd
    end)
  end
end

