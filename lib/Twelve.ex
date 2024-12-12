defmodule Twelve do
  def one(test \\ false) do
    Aoc24.char_map(12, test)
    |> then(
      &(&1
        |> Enum.reduce(%{}, fn {{y, x}, c}, acc ->
          ps =
            if(Map.get(&1, {y - 1, x}) != c, do: 1, else: 0) +
              if(Map.get(&1, {y + 1, x}) != c, do: 1, else: 0) +
              if(Map.get(&1, {y, x - 1}) != c, do: 1, else: 0) +
              if Map.get(&1, {y, x + 1}) != c, do: 1, else: 0

          Map.put(acc, {y, x}, {c, ps})
        end)
        |> create_groups([])
        |> Enum.reduce(0, fn group, acc ->
          acc +
            (group
             |> Enum.reduce({0, 0}, fn {_, {_, p}}, {pacc, aacc} -> {pacc + p, aacc + 1} end)
             |> then(fn {x, y} -> x * y end))
        end))
    )
  end

  def two(test \\ false) do
    Aoc24.char_map(12, test)
    |> then(
      &(&1
        |> Enum.reduce(%{}, fn {{y, x}, c}, acc ->
          ps =
            if(Map.get(&1, {y - 1, x}) != c, do: [{:t, {y, x}}], else: []) ++
              if(Map.get(&1, {y + 1, x}) != c, do: [{:b, {y, x}}], else: []) ++
              if(Map.get(&1, {y, x - 1}) != c, do: [{:l, {y, x}}], else: []) ++
              if Map.get(&1, {y, x + 1}) != c, do: [{:r, {y, x}}], else: []

          Map.put(acc, {y, x}, {c, ps})
        end)
        |> create_groups([])
        |> Enum.reduce(0, fn group, acc ->
          group = group |> Enum.to_list()
          sides = group |> Enum.flat_map(fn {_, {_, dirs}} -> dirs end)

          acc + merge_sides(sides, 0) * length(group)
        end))
    )
  end

  def merge_sides([], count), do: count

  def merge_sides([side | sides], count), do: merge_sides(filter_out_line(side, sides), count + 1)

  def filter_out_line({dir, {x, y}}, sides),
    do:
      sides
      |> Enum.split_with(fn {dir1, {x1, y1}} ->
        dir1 == dir and
          cond do
            dir1 in [:l, :r] ->
              y == y1 and abs(x1 - x) == 1

            dir1 in [:t, :b] ->
              x == x1 and abs(y1 - y) == 1
          end
      end)
      |> then(fn {paralells, rest} ->
        paralells
        |> Enum.reduce(rest, fn par, acc ->
          filter_out_line(par, acc)
        end)
      end)

  def create_groups(map, groups) do
    if Enum.empty?(map) do
      groups
    else
      {{y, x}, {c, cp}} = Map.to_list(map) |> List.first()

      acc =
        create_group(map, y, x, {c, cp}, %{{y, x} => {c, cp}})

      create_groups(Map.filter(map, fn {c, _} -> not Map.has_key?(acc, c) end), [acc | groups])
    end
  end

  def create_group(map, y, x, {c, _}, acc),
    do:
      add_plant(acc, map, c, y + 1, x)
      |> add_plant(map, c, y - 1, x)
      |> add_plant(map, c, y, x - 1)
      |> add_plant(map, c, y, x + 1)

  def add_plant(acc, map, plant, y, x) do
    # Make sure the adjacent plant exists, matches and we haven't added it already
    case {Map.get(map, {y, x}), Map.has_key?(acc, {y, x})} do
      {{^plant, rp}, false} ->
        create_group(map, y, x, {plant, rp}, Map.put(acc, {y, x}, {plant, rp}))

      _ ->
        acc
    end
  end
end
