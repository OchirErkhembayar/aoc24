defmodule Sixteen do
  def one(test \\ false), do: run(test)
  def two(test \\ false), do: run(test)

  defp run(test) do
    maze =
      Aoc24.char_map(16, test)

    {srcc, _} = maze |> Enum.find(fn {_, c} -> c == "S" end)
    {dst, _} = maze |> Enum.find(fn {_, c} -> c == "E" end)

    src = {srcc, :right, 0}

    bfs(dst, create_graph(maze), %{{srcc, :right} => 0}, [{src, [{srcc}]}], [])
    |> Enum.group_by(fn {{_, _, t}, _} -> t end)
    |> Enum.min_by(fn {t, _} -> t end)
    |> then(fn {t, paths} ->
      {t,
       paths
       |> Enum.reduce(MapSet.new(), fn {_, history}, tiles ->
         history
         |> Enum.reduce(tiles, fn coords, tiles -> MapSet.put(tiles, coords) end)
       end)
       |> MapSet.size()}
    end)
  end

  defp bfs(dst, vertices, visited, queue, dests) do
    case(List.pop_at(queue, -1)) do
      {nil, []} ->
        dests

      {{{^dst, _, _}, _} = vertex, queue} ->
        bfs(dst, vertices, visited, queue, [vertex | dests])

      {{{coords, dir, tokens}, history}, queue} ->
        adj_vertices =
          Enum.reduce(vertices[coords], [], fn adj_vertex, acc ->
            with {v, dir, cost} <- get_move(coords, adj_vertex, dir),
                 t when cost + tokens <= t <- Map.get(visited, {v, dir}) do
              [{v, dir, cost + tokens} | acc]
            else
              _ -> acc
            end
          end)

        visited =
          Enum.reduce(adj_vertices, visited, fn {v, dir, c}, acc ->
            Map.put(acc, {v, dir}, c)
          end)

        queue =
          Enum.reduce(adj_vertices, queue, fn {v, _, _} = adj, acc ->
            [{adj, [v | history]} | acc]
          end)

        bfs(dst, vertices, visited, queue, dests)
    end
  end

  defp get_move({x, y}, {xt, yt}, dir) do
    case(dir) do
      :up ->
        [
          {{x, y - 1}, :up, 1},
          {{x + 1, y}, :right, 1001},
          {{x - 1, y}, :left, 1001}
        ]

      :down ->
        [
          {{x, y + 1}, :down, 1},
          {{x - 1, y}, :left, 1001},
          {{x + 1, y}, :right, 1001}
        ]

      :left ->
        [
          {{x - 1, y}, :left, 1},
          {{x, y - 1}, :up, 1001},
          {{x, y + 1}, :down, 1001}
        ]

      :right ->
        [
          {{x + 1, y}, :right, 1},
          {{x, y - 1}, :up, 1001},
          {{x, y + 1}, :down, 1001}
        ]
    end
    |> Enum.find(fn {{x, y}, _, _} -> x == xt and y == yt end)
  end

  defp create_graph(maze),
    do:
      maze
      |> Enum.reduce(%{}, fn {{x, y}, c}, graph ->
        if c == "#" do
          graph
        else
          edges =
            [
              {x, y - 1},
              {x, y + 1},
              {x - 1, y},
              {x + 1, y}
            ]
            |> Enum.filter(fn {x, y} -> Map.get(maze, {x, y}) in ["E", "S", "."] end)

          Map.put(graph, {x, y}, edges)
        end
      end)
end
