defmodule MapNavigator do

end


IO.read(:stdio, :eof)
  |> String.split("\n\n")
  # |> (&MapNavigator.parse_network(&1)).()
  # |> (&MapNavigator.step_all(elem(&1, 1), elem(&1, 0))).()
  # |> Enum.map(&elem(&1, 1))
  # |> (&MapNavigator.calculate_lcm(&1)).()
  |> IO.inspect
