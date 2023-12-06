defmodule ScratchCards do
  def calculate_points(winning_numbers, my_numbers) do
    winning = winning_numbers
    |> Enum.map(&String.to_integer/1)
    |> Enum.zip(Stream.repeatedly(fn -> true end)|> Enum.take(length(winning_numbers)))
    |> Map.new
    Enum.map(my_numbers, &String.to_integer/1)
    |> Enum.map(&Map.has_key?(winning, &1))
    |> Enum.filter(fn e -> e; end)
    |> length()
    |> Kernel.-(1)
    |> (fn x -> if x >= 0 do :math.pow(2, x) else 0 end end).()
  end
end

IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.map(&String.split(&1, ":"))
  |> Enum.map(&tl/1)
  |> List.flatten()
  |> Enum.map(&String.trim/1)
  |> Enum.map(&String.split(&1, "|"))
  |> Enum.map(&Enum.map(&1, fn ele -> String.trim(ele) end))
  |> Enum.map(&Enum.map(&1, fn ele -> String.split(ele, ~r/ +/) end))
  |> Enum.map(fn ele -> ScratchCards.calculate_points(hd(ele), List.last(ele)) end)
  |> Enum.sum
  |> trunc()
  |> IO.inspect(charlists: :as_lists)
