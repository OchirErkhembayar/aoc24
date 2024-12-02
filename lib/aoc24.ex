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
        _ -> nil
      end

    if mod != nil do
      IO.puts(
        "Day #{day} | Part one: #{Integer.to_string(mod.one(test))} | Part two: #{Integer.to_string(mod.two(test))}"
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

  @spec read_file_lines_ints(integer(), boolean()) :: list(list(integer()))
  def read_file_lines_ints(day, test \\ false),
    do:
      read_file_lines_words(day, test)
      |> Enum.map(fn ws -> ws |> Enum.map(&(&1 |> String.to_integer())) end)
end
