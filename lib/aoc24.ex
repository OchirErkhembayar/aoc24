defmodule Aoc24 do
  def run_all(test \\ false) do
    1..25
    |> Enum.each(&run(&1, test))
  end

  def run(day, test \\ false) do
    mod =
      case day do
        1 -> One
        2 -> Two
        3 -> Three
        4 -> Four
        5 -> Five
        # Six runs way too slow right now
        6 -> nil
        7 -> Seven
        8 -> Eight
        # Nine pt. 2 is done in Rust in another project
        9 -> Nine
        10 -> Ten
        11 -> Eleven
        12 -> Twelve
        13 -> Thirteen
        14 -> Fourteen
        15 -> Fifteen
        16 -> Sixteen
        _ -> nil
      end

    if mod != nil do
      {one, two} =
        if mod == Sixteen do
          mod.one(test)
        else
          {mod.one(test), mod.two(test)}
        end

      IO.puts(
        "Day #{day} | Part one: #{Integer.to_string(one)} | Part two: #{Integer.to_string(two)}"
      )
    end
  end

  @spec read_file(integer(), boolean()) :: String.t()
  def read_file(day, test \\ false),
    do:
      ("data/" <>
         Integer.to_string(day) <>
         if(test,
           do: "t.txt",
           else: ".txt"
         ))
      |> File.read!()

  @spec read_file_lines(integer(), boolean()) :: list(String.t())
  def read_file_lines(day, test \\ false),
    do:
      read_file(day, test)
      |> String.split("\n", trim: true)

  @spec read_file_lines_words(integer(), boolean()) :: list(list(String.t()))
  def read_file_lines_words(day, test \\ false),
    do:
      read_file_lines(day, test)
      |> Enum.map(fn line -> line |> String.split(" ", trim: true) end)

  @spec read_lines_chars(integer(), boolean()) :: list(list(String.t()))
  def read_lines_chars(day, test \\ false),
    do: read_file_lines(day, test) |> Enum.map(&String.split(&1, "", trim: true))

  @spec read_file_lines_ints(integer(), boolean()) :: list(list(integer()))
  def read_file_lines_ints(day, test \\ false),
    do:
      read_file_lines_words(day, test)
      |> Enum.map(fn ws -> ws |> Enum.map(&(&1 |> String.to_integer())) end)

  @spec char_map(integer(), boolean()) :: map()
  def char_map(day, test \\ false),
    do:
      read_lines_chars(day, test)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {chars, row}, map ->
        Enum.with_index(chars)
        |> Enum.reduce(map, fn {c, col}, map ->
          Map.put(map, {col, row}, c)
        end)
      end)
end
