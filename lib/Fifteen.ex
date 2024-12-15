defmodule Fifteen do
  @print false

  def one(test \\ false) do
    [coords, moves] =
      Aoc24.read_file(15, test)
      |> String.split("\n\n", trim: true)
      |> then(fn [coords, moves] ->
        coords =
          coords
          |> String.split("\n", trim: true)
          |> Enum.map(fn line -> line |> String.split("", trim: true) end)

        moves =
          moves
          |> String.split("", trim: true)
          |> Enum.reduce([], fn c, acc ->
            if c in ["<", "^", "v", ">"] do
              [c | acc]
            else
              acc
            end
          end)
          |> Enum.reverse()

        [coords, moves]
      end)

    coords =
      coords
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, map ->
        line
        |> Enum.with_index()
        |> Enum.reduce(map, fn {c, x}, map ->
          Map.put(map, {x, y}, c)
        end)
      end)

    {{max_x, _}, _} = coords |> Enum.max_by(fn {{x, _}, _} -> x end)

    {{_, max_y}, _} =
      coords
      |> Enum.max_by(fn {{_, y}, _} -> y end)

    coords
    |> move(moves, max_x, max_y)
    |> Enum.reduce(0, fn {{x, y}, c}, acc ->
      if c == "O" do
        acc + (100 * y + x)
      else
        acc
      end
    end)
  end

  def move(map, [], _, _), do: map

  def move(map, [move | moves], max_x, max_y) do
    {{x, y}, _} =
      map
      |> Enum.find(fn {_, c} -> c == "@" end)

    case move do
      "^" ->
        case (y - 1)..0
             |> Enum.reduce_while(false, fn y, _ ->
               case Map.get(map, {x, y}) do
                 "O" -> {:cont, false}
                 "." -> {:halt, y}
                 "#" -> {:halt, false}
               end
             end) do
          false ->
            map

          limy ->
            limy..(y - 1)
            |> Enum.reduce(map, fn y, map ->
              Map.put(map, {x, y}, Map.get(map, {x, y + 1}))
            end)
            |> Map.put({x, y}, ".")
        end

      "v" ->
        case (y + 1)..max_y
             |> Enum.reduce_while(false, fn y, _ ->
               case Map.get(map, {x, y}) do
                 "O" -> {:cont, false}
                 "." -> {:halt, y}
                 "#" -> {:halt, false}
               end
             end) do
          false ->
            map

          limy ->
            limy..(y + 1)
            |> Enum.reduce(map, fn y, map ->
              Map.put(map, {x, y}, Map.get(map, {x, y - 1}))
            end)
            |> Map.put({x, y}, ".")
        end

      "<" ->
        case (x - 1)..0
             |> Enum.reduce_while(false, fn x, _ ->
               case Map.get(map, {x, y}) do
                 "O" -> {:cont, false}
                 "." -> {:halt, x}
                 "#" -> {:halt, false}
               end
             end) do
          false ->
            map

          limx ->
            limx..(x - 1)
            |> Enum.reduce(map, fn x, map ->
              Map.put(map, {x, y}, Map.get(map, {x + 1, y}))
            end)
            |> Map.put({x, y}, ".")
        end

      ">" ->
        case (x + 1)..max_x
             |> Enum.reduce_while(false, fn x, _ ->
               case Map.get(map, {x, y}) do
                 "O" -> {:cont, false}
                 "." -> {:halt, x}
                 "#" -> {:halt, false}
               end
             end) do
          false ->
            map

          limx ->
            limx..(x + 1)
            |> Enum.reduce(map, fn x, map ->
              Map.put(map, {x, y}, Map.get(map, {x - 1, y}))
            end)
            |> Map.put({x, y}, ".")
        end
    end
    |> move(moves, max_x, max_y)
  end

  def two(test \\ false) do
    [coords, moves] =
      Aoc24.read_file(15, test)
      |> String.split("\n\n", trim: true)
      |> then(fn [coords, moves] ->
        coords =
          coords
          |> String.split("\n", trim: true)
          |> Enum.map(fn line ->
            line
            |> String.split("", trim: true)
            |> Enum.flat_map(fn c ->
              case c do
                "@" -> ["@", "."]
                "O" -> ["[", "]"]
                c -> [c, c]
              end
            end)
          end)

        moves =
          moves
          |> String.split("", trim: true)
          |> Enum.reduce([], fn c, acc ->
            if c in ["<", "^", "v", ">"] do
              [c | acc]
            else
              acc
            end
          end)
          |> Enum.reverse()

        [coords, moves]
      end)

    coords =
      coords
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, map ->
        line
        |> Enum.with_index()
        |> Enum.reduce(map, fn {c, x}, map ->
          Map.put(map, {x, y}, c)
        end)
      end)

    {{_, max_y}, _} =
      coords
      |> Enum.max_by(fn {{_, y}, _} -> y end)

    {{max_x, _}, _} = coords |> Enum.max_by(fn {{x, _}, _} -> x end)

    map =
      coords
      |> move2(moves, max_x, max_y)

    if @print do
      0..max_y
      |> Enum.map(fn y ->
        0..max_x
        |> Enum.map(fn x -> Map.get(map, {x, y}) end)
        |> Enum.join("")
      end)
      |> Enum.join("\n")
      |> IO.puts()
    end

    map
    |> Enum.reduce(0, fn {{x, y}, c}, acc ->
      if c == "[",
        do: acc + (100 * y + x),
        else: acc
    end)
  end

  def move2(map, [], _, _), do: map

  def move2(map, [move | moves], max_x, max_y) do
    {{x, y}, _} =
      map
      |> Enum.find(fn {_, c} -> c == "@" end)

    {next_x, next_y} = next_pos(x, y, move)

    if(can_move(map, {next_x, next_y}, move),
      do: do_move(map, {x, y}, move),
      else: map
    )
    |> move2(moves, max_x, max_y)
  end

  def do_move(map, {x, y}, dir) do
    {next_x, next_y} = next_pos(x, y, dir)

    case Map.get(map, {next_x, next_y}) do
      "#" ->
        map

      "." ->
        Map.put(map, {next_x, next_y}, Map.get(map, {x, y}))

      "[" ->
        if dir in ["^", "v"] do
          do_move(map, {next_x + 1, next_y}, dir)
          |> do_move({next_x, next_y}, dir)
        else
          do_move(map, {next_x, next_y}, dir)
        end
        |> Map.put({next_x, next_y}, Map.get(map, {x, y}))

      "]" ->
        if dir in ["^", "v"] do
          do_move(map, {next_x - 1, next_y}, dir)
          |> do_move({next_x, next_y}, dir)
        else
          do_move(map, {next_x, next_y}, dir)
        end
        |> Map.put({next_x, next_y}, Map.get(map, {x, y}))
    end
    |> Map.put({x, y}, ".")
  end

  def can_move(map, {x, y}, dir) do
    {next_x, next_y} = next_pos(x, y, dir)

    case Map.get(map, {x, y}) do
      "#" ->
        false

      "." ->
        true

      "[" ->
        can_move(map, {next_x, next_y}, dir) and
          if dir not in ["<", ">"], do: can_move(map, {next_x + 1, next_y}, dir), else: true

      "]" ->
        can_move(map, {next_x, next_y}, dir) and
          if dir not in ["<", ">"], do: can_move(map, {next_x - 1, next_y}, dir), else: true
    end
  end

  defp next_pos(x, y, dir) do
    case dir do
      "^" -> {x, y - 1}
      "v" -> {x, y + 1}
      "<" -> {x - 1, y}
      ">" -> {x + 1, y}
    end
  end
end
