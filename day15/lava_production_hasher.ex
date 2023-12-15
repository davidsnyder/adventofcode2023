defmodule LavaProductionHasher do


end

IO.read(:stdio, :eof)
  |> String.split(&1,",")
  # |> Enum.map(&Enum.slice(&1, 1..-2))
  # |> (&LoadCalculator.transpose(&1)).()
  # |> Enum.map(&LoadCalculator.handle_row(&1))
  # |> (&LoadCalculator.transpose(&1)).()
  # |> Enum.map(&Enum.filter(&1, fn r -> r == LoadCalculator.round_rock end))
  # |> Enum.map(&Enum.count(&1))
  # |> Enum.reverse
  # |> Enum.with_index(1)
  # |> Enum.map(fn {a, b} -> a * b end)
  # |> Enum.sum
  |> IO.inspect(charlists: :as_lists, limit: :infinity)
