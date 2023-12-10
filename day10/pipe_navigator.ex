defmodule PipeNavigator do

end

IO.read(:stdio, :eof)
  |> String.split("\n")
  # |> Enum.map(&String.split(&1, " "))
  # |> Enum.map(&OasisSensor.predict(&1))
  # |> Enum.sum
  |> IO.inspect(charlists: :as_lists)
