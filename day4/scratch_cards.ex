defmodule ScratchCards do
  def calculate_matches(winning_numbers, my_numbers) do
    winning = winning_numbers
    |> Enum.map(&String.to_integer/1)
    |> Enum.zip(Stream.repeatedly(fn -> true end)|> Enum.take(length(winning_numbers)))
    |> Map.new
    Enum.map(my_numbers, &String.to_integer/1)
    |> Enum.map(&Map.has_key?(winning, &1))
    |> Enum.filter(fn e -> e; end)
    |> length()
  end

  # part 1
  def calculate_num_cards(winning_numbers, my_numbers) do
    calculate_matches(winning_numbers, my_numbers)
    |> Kernel.-(1)
    |> (fn x -> if x >= 0 do :math.pow(2, x) else 0 end end).()
  end

  # part 2
  def generate_copies(list, full_list) do
    if Enum.empty?(list) do
      0
    else
      [head | tail] = list
      copies = if elem(head, 0) > 0, do: Enum.slice(full_list, (elem(head, 1)+1)..(elem(head, 0)+elem(head, 1))), else: []
      1 + generate_copies(copies, full_list) + generate_copies(tail, full_list)
    end
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
  |> Enum.map(fn ele -> ScratchCards.calculate_matches(hd(ele), List.last(ele)) end)
  |> Enum.with_index
  |> (&ScratchCards.generate_copies(&1, &1)).()
  |> IO.inspect()
