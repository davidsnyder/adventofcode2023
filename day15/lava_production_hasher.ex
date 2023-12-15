defmodule LavaProductionHasher do
  def hash(str) do
    String.to_charlist(str)
    |> Enum.reduce(0, fn c, acc ->
      rem((acc + c) * 17, 256)
    end)
  end
end

IO.read(:stdio, :eof)
|> String.split(",")
|> Enum.map(&LavaProductionHasher.hash(&1))
|> Enum.sum()
|> IO.inspect(charlists: :as_lists, limit: :infinity)
