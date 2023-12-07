defmodule BoatCharger do
  def charges(race) do
    {time, record} = race
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
  |> Enum.map(fn l -> Enum.map(l, fn e -> String.to_integer(e) end) end)
  |> Enum.zip # [{7, 9}, {15, 40}, {30, 200}]
  |> Enum.map(&BoatCharger.charges(&1))
  |> Enum.map(fn e -> Enum.filter(elem(e, 1), fn t -> t > elem(e, 0) end) end)
  |> Enum.map(&length/1)
  |> Enum.reduce(1, fn e, acc -> e * acc end)
  |> IO.inspect(charlists: :as_lists)

  # ex. i have 7 seconds, record is 9
  # i can charge for 0, 1, 2, 3, 4, 5, 6, 7 seconds
  # i can go for     7, 6, 5, 4, 3, 2, 1, 0 seconds
  # i've traveled    0, 6,10,12,12,10, 6, 0 (multiply)
  # filter out any less than 9
  # [10, 12, 12, 10]
  # sum is 4
  # do that for each, multiply these together
