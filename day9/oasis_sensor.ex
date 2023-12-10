defmodule OasisSensor do
  def predict(history) do
    history
    |> Enum.reverse # part 2
    |> Enum.map(&String.to_integer(&1))
    |> (&diff_until_stable/1).()
  end

   def diff_until_stable(pairs) do
    IO.inspect(pairs, charlists: :as_lists)
    diff = pairs |> Enum.chunk_every(2, 1, :discard) |> Enum.map(fn pair -> [h, t | _rest] = pair; t - h end)
    if Enum.all?(diff, fn x -> x == 0 end) do
      List.last(pairs)
    else
      List.last(pairs) + diff_until_stable(diff)
    end
  end
end

IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.map(&String.split(&1, " "))
  |> Enum.map(&OasisSensor.predict(&1))
  |> Enum.sum
  |> IO.inspect(charlists: :as_lists)
