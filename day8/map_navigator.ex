defmodule MapNavigator do
  def parse_network(network) do
    [directions, nodes | _rest] = network
    directions
    |> String.split("")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> IO.inspect
    nodes
    |> String.split("\n")
  end
end

IO.read(:stdio, :eof)
  |> String.split("\n\n")
  |> (&MapNavigator.parse_network(&1)).()
  # |> Enum.map(&String.split(&1, " "))
  # |> Enum.map(&CamelCards.parse_rank(&1))
  # |> Enum.sort(fn {a_hand, _, a_rank}, {b_hand, _, b_rank} -> if b_rank == a_rank, do: CamelCards.tiebreaker(b_hand,a_hand), else: b_rank > a_rank end)
  # |> Enum.with_index(1)
  # #|> IO.inspect(charlists: :as_lists, limit: :infinity)
  # |> Enum.map(fn {{_h,b,_r},rr} -> b * rr end)
  # |> Enum.sum
  |> IO.inspect
