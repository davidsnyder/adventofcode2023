defmodule CubeMinimizer do

  def minimized_power(game) do
    parsed = parse(game)
    max_values(elem(parsed, 1))
  end

  def parse(game) do
    {game_str, game_num} = game
    handfulls = game_str
    |> String.split(":")
    |> List.last()
    |> CubeMinimizer.parse_handfulls()
    {game_num, handfulls}
  end

  def parse_handfulls(handfulls) do
    handfulls
    |> String.split(";")
    |> Enum.map(&CubeMinimizer.parse_handfull/1)
  end

  # "3 blue, 4 red" -> [3,4,0]
  def parse_handfull(handfull) do
    parsed = handfull
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&CubeMinimizer.parse_selection/1)
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

  #[[3, 4, 0], [6, 1, 2], [0, 0, 2]] -> [6, 4, 2] -> 6 * 4 * 2 -> 48
  def max_values(game) do
    game
    |> Enum.reduce([0,0,0], &CubeMinimizer.reducer_func(&1, &2))
    |> Enum.reduce(1, fn ele, power -> power * ele end)
  end

  def reducer_func(selection, vals) do
    Enum.zip(selection, vals)
    |> Enum.map(fn {a, b} -> if a > b do a else b end end)
  end
end

#check_values = [14, 12, 13] # blue, red, green
input = IO.read(:stdio, :eof)
input
  |> String.split("\n")
  |> Enum.with_index(1) #shortcut for game number
  |> Enum.map(&CubeMinimizer.minimized_power(&1))
  |> Enum.reduce(0, fn ele, sum -> sum + ele end)
  |> IO.puts()
