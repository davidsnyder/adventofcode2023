defmodule GearRatios do
  @regex ~r/[0-9.]/
  def search_adjacent(matrix, row_index, row) do
    height = map_size(matrix)
    width = String.length(matrix[0])
    #IO.puts("#{width}, #{height}")
    words = Regex.scan(~r/[0-9]+/, row)
    indexes = Regex.scan(~r/[0-9]+/, row, return: :index)
    Enum.zip(List.flatten(words), List.flatten(indexes))
    |> Enum.map(&GearRatios.generate_coordinates(row_index, &1))
    |> Enum.map(fn {num, coords} -> {num, Enum.filter(coords, fn {x, y} -> x >= 0 and x < height and y >= 0 and y < width; end)} end)
    |> Enum.map(fn {num, coords} -> {num, Enum.map(coords, fn {x, y} -> String.at(matrix[x], y) end)} end)
    |> Enum.map(fn {num, chars} -> {num, Enum.filter(chars, fn char -> char != "." and not Regex.match?(@regex, char) end)} end)
    |> Enum.filter(fn {_num, chars} -> length(chars) > 0 end)
    |> Enum.map(&elem(&1, 0))
    |> Enum.reduce(0, fn ele, sum -> sum + ele; end)

  end

  def generate_coordinates(x, {num, {y, length}}) do
    coords = for n_x <- (x-1)..(x+1),
      n_y <- (y-1)..(y+length) do
        {n_x,n_y}
      end
      {String.to_integer(num), coords}
  end
end

input = IO.read(:stdio, :eof)
matrix_map = input
  |> String.split("\n")
  |> Enum.with_index()
  |> Enum.to_list()
  |> Enum.map(fn tup -> {elem(tup,1), elem(tup,0)}; end)
  |> Map.new

matrix_map
  |> Enum.map(fn {k, v} ->  GearRatios.search_adjacent(matrix_map, k, v); end)
  |> Enum.reduce(0, fn ele, sum -> sum + ele; end)
  |> IO.puts
