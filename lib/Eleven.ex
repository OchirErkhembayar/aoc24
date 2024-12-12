defmodule Eleven do
  require Integer

  def one(test \\ false), do: run(test, 25)

  def two(test \\ false), do: run(test, 75)

  def run(test, blinks) do
    Aoc24.read_file(11, test)
    |> String.split([" ", "\n"], trim: true)
    |> Enum.reduce(%{}, fn s, stones ->
      Map.update(stones, String.to_integer(s), 1, &(&1 + 1))
    end)
    |> blink(blinks)
  end

  def blink(stones, 0), do: stones |> Enum.reduce(0, fn {_, c}, acc -> c + acc end)

  def blink(stones, times) do
    stones
    |> Enum.reduce(%{}, fn {n, freq}, stones ->
      cond do
        n == 0 ->
          Map.update(stones, 1, freq, &(&1 + freq))

        n |> Integer.digits() |> Enum.count() |> Integer.is_odd() ->
          Map.update(stones, n * 2024, freq, &(&1 + freq))

        true ->
          digits = n |> Integer.digits()
          {left, right} = digits |> Enum.split(((digits |> Enum.count()) / 2) |> trunc())

          Map.update(stones, left |> Integer.undigits(), freq, &(&1 + freq))
          |> Map.update(right |> Integer.undigits(), freq, &(&1 + freq))
      end
    end)
    |> blink(times - 1)
  end
end
