defmodule Six do
  def one(test \\ false) do
    char_map = Aoc24.char_map(6, test)

    before = Time.utc_now()
    res = run(char_map, %{})

    then = Time.utc_now()
    {res, Time.diff(before, then)}
  end

  def two(test \\ false) do
    # if you're in the same spot w/ the same dir you're in a loop
    before = Time.utc_now()
    map = Aoc24.char_map(6, test)

    perms =
      for(
        {{h, w}, c} <- map |> Enum.sort(),
        do: if(c == ".", do: Map.put(map, {h, w}, "#"), else: map)
      )

    {{{h, _}, _}, {{_, w}, _}} =
      {Enum.max_by(perms |> List.first(), fn {{h, _}, _} -> h end),
       Enum.max_by(perms |> List.first(), fn {{_, w}, _} -> w end)}

    res =
      Enum.reduce(perms, 0, fn p, acc ->
        if run2(p, h, w, %{}), do: acc + 1, else: acc
      end)

    then = Time.utc_now()
    {res, Time.diff(before, then)}
  end

  def run2(char_map, h, w, visited) do
    # Find starting position
    case char_map
         |> Enum.find(fn {_, v} -> v != "." and v != "#" end) do
      nil ->
        false

      {pos, dir} ->
        case update_map2(dir, h, w, pos, char_map, visited) do
          {new_map, new_moves} ->
            run2(new_map, h, w, new_moves)

          true ->
            true
        end
    end
  end

  def update_map2(dir, height, width, {h, w}, map, visited) do
    map = Map.update!(map, {h, w}, fn _ -> "." end)

    case dir do
      "^" ->
        h..-1
        |> Enum.reduce_while(visited, fn h, moves ->
          case Map.get(map, {h, w}) do
            nil ->
              {:halt, {map, moves}}

            c ->
              if c == "#" do
                if Map.get(moves, {h + 1, w}, []) |> Enum.any?(fn d -> d == ">" end) do
                  {:halt, true}
                else
                  {:halt,
                   {Map.update!(map, {h + 1, w}, fn _ -> ">" end),
                    Map.update(moves, {h + 1, w}, [">"], fn dirs -> [">" | dirs] end)}}
                end
              else
                {:cont, moves}
              end
          end
        end)

      "v" ->
        h..(height + 1)
        |> Enum.reduce_while(visited, fn h, moves ->
          case Map.get(map, {h, w}) do
            nil ->
              {:halt, {map, moves}}

            c ->
              if c == "#" do
                if Map.get(moves, {h - 1, w}, []) |> Enum.any?(fn d -> d == "<" end) do
                  {:halt, true}
                else
                  {:halt,
                   {Map.update!(map, {h - 1, w}, fn _ -> "<" end),
                    Map.update(moves, {h - 1, w}, ["<"], fn dirs -> ["<" | dirs] end)}}
                end
              else
                {:cont, moves}
              end
          end
        end)

      ">" ->
        w..(width + 1)
        |> Enum.reduce_while(visited, fn w, moves ->
          case Map.get(map, {h, w}) do
            nil ->
              {:halt, {map, moves}}

            c ->
              if c == "#" do
                if Map.get(moves, {h, w - 1}, [])
                   |> Enum.any?(fn d -> d == "v" end) do
                  {:halt, true}
                else
                  {:halt,
                   {Map.update!(map, {h, w - 1}, fn _ -> "v" end),
                    Map.update(moves, {h, w - 1}, ["v"], fn dirs -> ["v" | dirs] end)}}
                end
              else
                {:cont, moves}
              end
          end
        end)

      "<" ->
        w..-1
        |> Enum.reduce_while(visited, fn w, moves ->
          case Map.get(map, {h, w}) do
            nil ->
              {:halt, {map, moves}}

            c ->
              if c == "#" do
                if Map.get(moves, {h, w + 1}, []) |> Enum.any?(fn d -> d == "^" end) do
                  {:halt, true}
                else
                  {:halt,
                   {Map.update!(map, {h, w + 1}, fn _ -> "^" end),
                    Map.update(moves, {h, w + 1}, ["^"], fn dirs -> ["^" | dirs] end)}}
                end
              else
                {:cont, moves}
              end
          end
        end)
    end
  end

  def run(char_map, visited) do
    {{{h, _}, _}, {{_, w}, _}} =
      {Enum.max_by(char_map, fn {{h, _}, _} -> h end),
       Enum.max_by(char_map, fn {{_, w}, _} -> w end)}

    # Find starting position
    case char_map
         |> Enum.find(fn {_, v} -> v != "." and v != "#" end) do
      nil ->
        Map.keys(visited) |> Enum.count()

      {pos, dir} ->
        {new_map, new_moves} = update_map(dir, h, w, pos, char_map, visited)
        run(new_map, new_moves)
    end
  end

  def update_map(dir, height, width, {h, w}, map, visited) do
    map = Map.update!(map, {h, w}, fn _ -> "." end)

    case dir do
      "^" ->
        h..-1
        |> Enum.reduce_while(visited, fn h, moves ->
          case Map.get(map, {h, w}) do
            nil ->
              {:halt, {map, moves}}

            c ->
              if c == "#" do
                {:halt, {Map.update!(map, {h + 1, w}, fn _ -> ">" end), moves}}
              else
                {:cont, Map.update(moves, {h, w}, 1, fn dirs -> [">" | dirs] end)}
              end
          end
        end)

      "v" ->
        h..(height + 1)
        |> Enum.reduce_while(visited, fn h, moves ->
          case Map.get(map, {h, w}) do
            nil ->
              {:halt, {map, moves}}

            c ->
              if c == "#" do
                {:halt, {Map.update!(map, {h - 1, w}, fn _ -> "<" end), moves}}
              else
                {:cont, Map.update(moves, {h, w}, 1, &(&1 + 1))}
              end
          end
        end)

      ">" ->
        w..(width + 1)
        |> Enum.reduce_while(visited, fn w, moves ->
          case Map.get(map, {h, w}) do
            nil ->
              {:halt, {map, moves}}

            c ->
              if c == "#" do
                {:halt, {Map.update!(map, {h, w - 1}, fn _ -> "v" end), moves}}
              else
                {:cont, Map.update(moves, {h, w}, 1, &(&1 + 1))}
              end
          end
        end)

      "<" ->
        w..-1
        |> Enum.reduce_while(visited, fn w, moves ->
          case Map.get(map, {h, w}) do
            nil ->
              {:halt, {map, moves}}

            c ->
              if c == "#" do
                {:halt, {Map.update!(map, {h, w + 1}, fn _ -> "^" end), moves}}
              else
                {:cont, Map.update(moves, {h, w}, 1, &(&1 + 1))}
              end
          end
        end)
    end
  end
end
