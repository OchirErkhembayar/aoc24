defmodule Five do
  def one(test \\ false) do
    [pairs, updates] =
      Aoc24.read_file(5, test)
      |> String.split("\n\n", trim: true)

    reqs =
      pairs
      |> String.split("\n", trim: true)
      |> Enum.map(&(&1 |> String.split("|") |> Enum.map(fn s -> String.to_integer(s) end)))
      |> Enum.reduce(%{}, fn [bef, aft], reqs ->
        reqs |> Map.update(aft, [bef], fn befores -> [bef | befores] end)
      end)

    updates
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> String.split(",") |> Enum.map(fn s -> String.to_integer(s) end)))
    |> Enum.filter(fn nums -> valid?(nums, reqs) end)
    |> Enum.map(fn nums -> Enum.at(nums, (length(nums) / 2) |> floor()) end)
    |> Enum.sum()
  end

  def two(test \\ false) do
    [pairs, updates] =
      Aoc24.read_file(5, test)
      |> String.split("\n\n", trim: true)

    reqs =
      pairs
      |> String.split("\n", trim: true)
      |> Enum.map(&(&1 |> String.split("|") |> Enum.map(fn s -> String.to_integer(s) end)))
      |> Enum.reduce(%{}, fn [bef, aft], reqs ->
        reqs |> Map.update(aft, [bef], fn befores -> [bef | befores] end)
      end)

    updates
    |> String.split("\n", trim: true)
    |> Enum.map(&(&1 |> String.split(",") |> Enum.map(fn s -> String.to_integer(s) end)))
    |> Enum.filter(fn nums -> not valid?(nums, reqs) end)
    |> Enum.reduce(0, fn nums, acc ->
      acc +
        (sort(nums, reqs, [])
         |> Enum.reverse()
         |> then(fn nums -> Enum.at(nums, (length(nums) / 2) |> floor()) end))
    end)
  end

  def sort([fst | nums], reqs, []), do: sort(nums, reqs, [fst])
  def sort([], _, new_nums), do: new_nums

  def sort([fst | nums], reqs, new_nums) do
    case new_nums
         |> Enum.with_index()
         |> Enum.find(fn {n, _} ->
           befores = Map.get(reqs, n, [])
           Enum.all?(befores, fn b -> b != fst end)
         end) do
      nil ->
        sort(nums, reqs, new_nums ++ [fst])

      {_, i} ->
        sort(nums, reqs, List.insert_at(new_nums, i, fst))
    end
  end

  def valid?(nums, _) when length(nums) < 2, do: true

  def valid?([fst | rest], reqs) do
    invalids = Map.get(reqs, fst, [])

    if Enum.any?(rest, fn front -> Enum.any?(invalids, fn match -> front == match end) end) do
      false
    else
      valid?(rest, reqs)
    end
  end
end
