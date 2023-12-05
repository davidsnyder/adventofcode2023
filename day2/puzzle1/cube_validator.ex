defmodule CubeValidator do

  # Parse games into a map of lists
  # Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  # {1, [[3,4,0], [0,4,2], [0,0,2]]}
  # The order of each list is [blue, red, green]

  def validate(check_values, game) do
    parsed = parse(game)
    {elem(parsed, 0), was_possible(check_values, elem(parsed, 1))}
  end

  def parse(game) do
    {game_str, game_num} = game
    handfulls = game_str
    |> String.split(":")
    |> List.last()
    |> CubeValidator.parse_handfulls()
    {game_num, handfulls}
  end

  def parse_handfulls(handfulls) do
    handfulls
    |> String.split(";")
    |> Enum.map(&CubeValidator.parse_handfull/1)
  end

  # "3 blue, 4 red" -> [3,4,0]
  def parse_handfull(handfull) do
    parsed = handfull
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&CubeValidator.parse_selection/1)
    |> Map.new()
    [Map.get(parsed, "blue", 0),Map.get(parsed, "red", 0), Map.get(parsed, "green", 0)]
  end

  # "3 blue" -> {"blue", 3}
  def parse_selection(selection) do
    [count_str, color] = selection
    |> String.split(" ")
    |> Enum.map(&String.trim/1)
    count = String.to_integer(count_str, 10)
    {color, count}
  end

  # [14, 12, 13]
  # [[1,2,3]]
  # check that all entries in @game are <= the corresponding values of check_values
  def was_possible(check_values, game) do
    game
    |> Enum.map(&Enum.zip(check_values, &1) |> Enum.map(fn {a, b} -> a - b end))
    |> Enum.map(&Enum.all?(&1, fn x -> x >= 0 end))
    |> Enum.reduce(true, fn ele, result -> result and ele end)
  end
end

check_values = [14, 12, 13] # blue, red, green
input = IO.read(:stdio, :eof)
input
  |> String.split("\n")
  |> Enum.with_index(1) #shortcut for game number
  |> Enum.map(&CubeValidator.validate(check_values, &1))
  |> Enum.reduce(0, fn game, sum -> if elem(game, 1) do sum + elem(game, 0) else sum end; end)
  |> IO.puts()
