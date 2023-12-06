defmodule GearRatios do

  def search_adjacent(matrix, row_index, row) do
    height = map_size(matrix)
    width = String.length(matrix[0])
    words = Regex.scan(~r/[0-9]+/, row)
    indexes = Regex.scan(~r/[0-9]+/, row, return: :index)
    Enum.zip(List.flatten(words), List.flatten(indexes))
    |> Enum.map(&GearRatios.generate_coordinates(row_index, &1))
    |> Enum.map(fn {num, coords} -> {num, Enum.filter(coords, fn {x, y} -> x >= 0 and x < height and y >= 0 and y < width; end)} end)
    |> Enum.map(fn {num, coords} -> {num, Enum.map(coords, fn {x, y} -> {{x,y}, String.at(matrix[x], y)} end)} end)
    |> Enum.map(fn {num, chars} -> {num, Enum.filter(chars, fn {_coords, char} -> char == "*" end)} end)
    |> Enum.filter(fn {_num, chars} -> length(chars) > 0 end)
    |> Enum.map(fn {num, chars} -> {num, List.first(chars)} end)
    |> Enum.map(fn {num, {{x,y}, _c}} -> {"#{x},#{y}", num} end)
  end

  # this also includes the coordinates of the number itself, but we'll just filter those out later
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

  # part 1
  # build a 2d matrix out of the input
  # find the indices of the numbers in it (using a regexp)
  # generate the x,y coordinates surrounding each number that need to be searched for symbols
  # find the numbers that have symbols adjacent
  # sum these together

  # matrix_map
  # |> Enum.map(fn {k, v} ->  GearRatios.search_adjacent(matrix_map, k, v); end)
  # |> Enum.reduce(0, fn ele, sum -> sum + ele; end)
  # |> IO.puts

  # part 2
  # need to save the coordinates of the symbols (we already have them)
  # then see if two numbers share the same coordinates
  # if they do, multiply them together
  # then sum these together

  matrix_map
  |> Enum.map(fn {k, v} ->  GearRatios.search_adjacent(matrix_map, k, v); end)
  |> List.flatten()
  |> Enum.reduce(%{}, fn {key, value}, acc ->
    case Map.get(acc, key) do
      nil -> Map.put(acc, key, [value])
      existing_list -> Map.put(acc, key, [value | existing_list])
    end
  end)
  |> Map.values
  |> Enum.filter(fn l -> length(l) == 2; end)
  #|> IO.inspect(charlists: :as_lists)
  |> Enum.map(fn [a, b] -> a * b; end)
  |> Enum.sum()
  |> IO.puts
