defmodule BoatCharger do
  def charges(race) do
    [time, record | _rest] = race
    {record, Enum.map(Range.to_list(0..time), fn t -> t * (time - t) end)}
  end
end

IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.map(&String.split(&1, ":"))
  |> Enum.map(&tl(&1))
  |> List.flatten
  |> Enum.map(&String.trim(&1))
  |> Enum.map(&String.split(&1, ~r/ +/))
  |> Enum.map(&Enum.join/1)
  |> Enum.map(&String.to_integer/1)
  #|> Enum.zip # [{7, 9}, {15, 40}, {30, 200}]
  |> (&BoatCharger.charges(&1)).()
  |> (&Enum.filter(elem(&1, 1), fn t -> t > elem(&1, 0) end)).()
  |> (&length/1).()
  #|> Enum.reduce(1, fn e, acc -> e * acc end)
  |> IO.inspect(charlists: :as_lists)

  # ex. i have 7 seconds, record is 9
  # i can charge for 0, 1, 2, 3, 4, 5, 6, 7 seconds
  # i can go for     7, 6, 5, 4, 3, 2, 1, 0 seconds
  # i've traveled    0, 6,10,12,12,10, 6, 0 (multiply)
  # filter out any less than 9
  # [10, 12, 12, 10]
  # sum is 4
  # do that for each, multiply these together
