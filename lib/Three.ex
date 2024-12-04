defmodule Three do
  def one(test \\ false) do
    input = Aoc24.read_file(3, test) |> String.split("", trim: true)

    one(input, 0)
  end

  def o2(test \\ false) do
    input = Aoc24.read_file(3, test)

    Regex.scan(~r/mul\((\d+),(\d+)\)/, input)
    |> Enum.reduce(0, fn [_, l, r], sum -> sum + String.to_integer(l) * String.to_integer(r) end)
  end

  def t2(test \\ false) do
    input = Aoc24.read_file(3, test)

    # why no work man
    Regex.scan(~r/mul\((\d+),(\d+)|don't\(\)|do\(\)/, input)
    |> Enum.reduce({0, true}, fn match, {sum, enabled} ->
      case match do
        [_, l, r] when enabled ->
          {sum + String.to_integer(l) * String.to_integer(r), enabled}

        ["don't()"] ->
          {sum, false}

        ["do()"] ->
          {sum, true}

        _ ->
          {sum, enabled}
      end
    end)
  end

  defp one(["m", "u", "l", "(" | rest], sum) do
    with {lnum, ["," | rest]} <-
           rest |> Enum.split_while(fn c -> hd(to_charlist(c)) in ?0..?9 end),
         {rnum, [")" | rest]} <-
           rest |> Enum.split_while(fn c -> hd(to_charlist(c)) in ?0..?9 end) do
      lnum = Enum.join(lnum, "") |> String.to_integer()
      rnum = Enum.join(rnum, "") |> String.to_integer()
      one(rest, sum + rnum * lnum)
    else
      _ -> one(rest, sum)
    end
  end

  defp one([_ | rest], sum), do: one(rest, sum)
  defp one([], sum), do: sum

  def two(test \\ false) do
    input = Aoc24.read_file(3, test) |> String.split("", trim: true)

    two(input, 0, true)
  end

  defp two(["m", "u", "l", "(" | rest], sum, true) do
    with {lnum, ["," | rest]} <-
           rest |> Enum.split_while(fn c -> hd(to_charlist(c)) in ?0..?9 end),
         {rnum, [")" | rest]} <-
           rest |> Enum.split_while(fn c -> hd(to_charlist(c)) in ?0..?9 end) do
      lnum = Enum.join(lnum, "") |> String.to_integer()
      rnum = Enum.join(rnum, "") |> String.to_integer()
      two(rest, sum + rnum * lnum, true)
    else
      _ -> two(rest, sum, true)
    end
  end

  defp two(["d", "o", "(", ")" | rest], sum, _), do: two(rest, sum, true)
  defp two(["d", "o", "n", "'", "t", "(", ")" | rest], sum, _), do: two(rest, sum, false)
  defp two([_ | rest], sum, enabled), do: two(rest, sum, enabled)
  defp two([], sum, _), do: sum
end
