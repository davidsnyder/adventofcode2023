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
  def generate_copies(queue, full_list, num_cards) do
    if :queue.is_empty(queue) do # base case
      num_cards
    else # recur
      {{_, val}, new_queue} = :queue.out(queue)
      if elem(val, 0) > 0 do # winning numbers > 0
        copies = Enum.slice(full_list, (elem(val, 1)+1)..(elem(val, 0)+elem(val, 1))) # get copies
        generate_copies(:queue.join(new_queue, :queue.from_list(copies)), full_list, num_cards + 1)
      else # without winning numbers there's no copies, just add to the total count
        generate_copies(new_queue, full_list, num_cards + 1)
      end
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
  |> (&ScratchCards.generate_copies(:queue.from_list(&1), &1, 0)).()
  |> IO.inspect()
