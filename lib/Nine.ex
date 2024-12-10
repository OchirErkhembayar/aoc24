defmodule Nine do
  def one(test \\ false) do
    {files, _, _} =
      Aoc24.read_file(9, test)
      |> String.trim()
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce({[], true, 0}, fn size, {files, is_file, next_id} ->
        if size == 0 do
          {files, not is_file, if(is_file, do: next_id + 1, else: next_id)}
        else
          next = %{
            size: size,
            is_file: is_file,
            id: next_id
          }

          {[next | files], not is_file, if(is_file, do: next_id + 1, else: next_id)}
        end
      end)

    run(files |> Enum.reverse(), [])
    |> Enum.reverse()
    |> tally(0, 0)
  end

  def tally([], _, acc), do: acc

  def tally([%{id: id, size: size} | rest], idx, acc) do
    if size > 1 do
      tally([%{id: id, size: size - 1} | rest], idx + 1, acc + id * idx)
    else
      tally(rest, idx + 1, acc + id * idx)
    end
  end

  def run([], final), do: final

  def run([%{is_file: true} = file | files], final) do
    run(files, [file | final])
  end

  def run([_], final) do
    final
  end

  def run([%{is_file: false, size: free_size, id: free_id} = first | files], final) do
    {last, files} = List.pop_at(files, Enum.count(files) - 1)

    case last do
      %{is_file: false} ->
        run([first | files], final)

      %{is_file: true, size: file_size, id: file_id} ->
        cond do
          free_size > file_size ->
            run([%{is_file: false, size: free_size - file_size, id: free_id} | files], [
              %{id: file_id, size: file_size} | final
            ])

          free_size < file_size ->
            run(files ++ [%{is_file: true, size: file_size - free_size, id: file_id}], [
              %{size: free_size, id: file_id} | final
            ])

          free_size == file_size ->
            run(files, [%{size: file_size, id: file_id} | final])
        end
    end
  end

  def two(test \\ false) do
    Aoc24.read_file(9, test)
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce({[], true, 0}, fn size, {files, is_file, next_id} ->
      if size == 0 do
        {files, not is_file, if(is_file, do: next_id + 1, else: next_id)}
      else
        next = %{
          size: size,
          is_file: is_file,
          id: next_id
        }

        {[next | files], not is_file, if(is_file, do: next_id + 1, else: next_id)}
      end
    end)
    |> then(fn {files, _, _} -> files |> Enum.reverse() end)
  end

  def run2(files) do
    {file_files, [%{size: free_size, id: free_id, is_file: false} | rest_files]} =
      Enum.split_while(files, fn %{is_file: is_file} -> is_file end)
      |> IO.inspect()

    # find a file block that fits
    case find(free_size, rest_files) do
      nil ->
        files

      {%{size: size, id: file_id}, rest_files} ->
        cond do
          free_size > size ->
            run2(
              file_files ++
                [
                  %{size: size, id: file_id, is_file: true},
                  %{size: free_size - size, id: free_id, is_file: false} | rest_files
                ]
            )

          free_size < size ->
            raise "Impossible"

          free_size == size ->
            IO.inspect("Hi")
            run2(file_files ++ [%{size: size, id: file_id, is_file: true} | rest_files])
        end
    end
  end

  def f(files, max_size) do
    rev_files = files |> Enum.reverse()

    case rev_files
         |> Enum.find_index(fn %{is_file: is_file, size: size} -> is_file and size <= max_size end) do
      nil ->
        nil

      idx ->
        List.pop_at(rev_files, idx) |> then(fn {file, rest} -> {file, rest |> Enum.reverse()} end)
    end
  end

  def find(max_size, rest_files) do
    reversed = rest_files |> Enum.reverse()

    case reversed
         |> Enum.find_index(fn %{size: size, is_file: is_file} -> is_file and size <= max_size end) do
      nil ->
        nil

      idx ->
        reversed
        |> List.pop_at(idx)
        |> then(fn {file, rev_rest} -> {file, rev_rest |> Enum.reverse()} end)
    end
  end
end
