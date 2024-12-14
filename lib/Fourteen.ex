defmodule Fourteen do
  @width 101
  @height 103

  @middle_x (@width - 1) / 2
  @middle_y (@height - 1) / 2

  def one(test \\ false),
    do:
      run(test, 100)
      |> Enum.reduce([0, 0, 0, 0], fn {{px, py}, _}, [tl, tr, bl, br] ->
        cond do
          px < @middle_x and py < @middle_y -> [tl + 1, tr, bl, br]
          px > @middle_x and py < @middle_y -> [tl, tr + 1, bl, br]
          px < @middle_x and py > @middle_y -> [tl, tr, bl + 1, br]
          px > @middle_x and py > @middle_y -> [tl, tr, bl, br + 1]
          true -> [tl, tr, bl, br]
        end
      end)
      |> Enum.product()

  def two(test \\ false),
    do:
      run(test, 6398)
      |> then(fn map ->
        y_coords = 0..(@width - 1) |> Enum.map(fn x -> rem(x, 10) end) |> Enum.join(" ")
        IO.puts("  " <> y_coords)

        0..(@height - 1)
        |> Enum.each(fn y ->
          row =
            0..@width
            |> Enum.map(fn x ->
              if Map.has_key?(map, {x, y}) do
                "^"
              else
                " "
              end
            end)
            |> Enum.join(" ")

          IO.puts(Integer.to_string(rem(y, 10)) <> " " <> row)
        end)

        42
      end)

  def run(test, moves),
    do:
      Aoc24.read_file_lines(14, test)
      |> Enum.map(fn s ->
        String.split(s, ["p=", " v="], trim: true)
        |> Enum.map(fn s ->
          s |> String.split(",") |> Enum.map(fn s -> String.to_integer(s) end)
        end)
      end)
      |> Enum.reduce(%{}, fn [[px, py], [vx, vy]], map ->
        Map.update(map, {px, py}, [{vx, vy}], fn vels -> [{vx, vy} | vels] end)
      end)
      |> move(moves)

  def move(map, 0), do: map

  def move(map, moves),
    do:
      map
      |> Enum.reduce(%{}, fn {{px, py}, velocities}, new_map ->
        velocities
        |> Enum.reduce(new_map, fn {vx, vy}, map ->
          new_x = px + vx

          new_x =
            cond do
              new_x >= @width -> rem(new_x, @width)
              new_x < 0 -> @width + rem(new_x, @width)
              true -> new_x
            end

          new_y = py + vy

          new_y =
            cond do
              new_y >= @height -> rem(new_y, @height)
              new_y < 0 -> @height + rem(new_y, @height)
              true -> new_y
            end

          Map.update(map, {new_x, new_y}, [{vx, vy}], fn vels -> [{vx, vy} | vels] end)
        end)
      end)
      |> move(moves - 1)
end
