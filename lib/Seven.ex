defmodule Seven do
  def one(test \\ false),
    do:
      data(test)
      |> Enum.reduce(0, fn line, acc ->
        if valid?(line, false), do: List.first(line) + acc, else: acc
      end)

  def two(test \\ false),
    do:
      data(test)
      |> Enum.reduce(0, fn line, acc ->
        if valid?(line, true), do: List.first(line) + acc, else: acc
      end)

  def valid?([goal, fst | comps], part_two),
    do: valid?(comps, fst, goal, part_two)

  def valid?([x], curr, goal, part_two),
    do:
      curr + x == goal or curr * x == goal or
        if(part_two,
          do: (Integer.digits(curr) ++ Integer.digits(x)) |> Integer.undigits() == goal,
          else: false
        )

  def valid?([fst | rest], curr, goal, part_two) do
    valid?(rest, curr + fst, goal, part_two) or
      valid?(rest, curr * fst, goal, part_two) or
      if part_two,
        do:
          valid?(
            rest,
            (Integer.digits(curr) ++ Integer.digits(fst)) |> Integer.undigits(),
            goal,
            part_two
          ),
        else: false
  end

  defp data(test),
    do:
      Aoc24.read_file_lines(7, test)
      |> Enum.map(fn l ->
        String.split(l, [" ", ": "], trim: true)
        |> Enum.map(fn n -> String.to_integer(n) end)
      end)
end
