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
        |> Enum.any?(&valid(List.delete_at(report, &1)))
    end)
  end

  defp valid([fst, snd | _] = report), do: valid(report, fst < snd)

  defp valid([fst, snd | _], asc)
       when abs(fst - snd) > 3 or fst == snd or (asc and fst > snd) or (not asc and fst < snd),
       do: false

  defp valid([_, _], _), do: true
  defp valid([_, snd | rest], asc), do: valid([snd | rest], asc)
end

