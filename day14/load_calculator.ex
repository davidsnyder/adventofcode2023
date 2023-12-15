defmodule LoadCalculator do
  @round_rock "O"
  @nothing "."

  def round_rock do
    @round_rock
  end

  def transpose(matrix) do
    matrix
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
  end

  def handle_row(row) do
    shift_rocks_n_times(row, length(row))
  end

  def shift_rocks_n_times(l, 0), do: l
  def shift_rocks_n_times(l, n) do
    shifted = shift_rocks(l)
    #IO.inspect(shifted)
    shift_rocks_n_times(shifted, n-1)
  end

  def shift_rocks([]), do: []
  def shift_rocks([head]), do: [head]

  def shift_rocks(row) do
    [head , next | rest] = row
    case {head, next} do
    {@nothing, @round_rock} ->
      [next] ++ shift_rocks([head | rest])
    _ ->
      [head] ++ shift_rocks([next | rest])
    end
  end

end

IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.map(&String.split(&1,""))
  |> Enum.map(&Enum.slice(&1, 1..-2))
  |> (&LoadCalculator.transpose(&1)).()

  |> Enum.map(&LoadCalculator.handle_row(&1))
  |> (&LoadCalculator.transpose(&1)).()
  |> Enum.map(&Enum.filter(&1, fn r -> r == LoadCalculator.round_rock end))
  |> Enum.map(&Enum.count(&1))
  |> Enum.reverse
  |> Enum.with_index(1)
  |> Enum.map(fn {a, b} -> a * b end)
  |> Enum.sum
  |> IO.inspect(charlists: :as_lists, limit: :infinity)
