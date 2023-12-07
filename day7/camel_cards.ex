defmodule CamelCards do
  @handsize 5
  @ranks [[5], [4,1], [3,2], [3,1,1], [2,2,1], [2,1,1,1], [1,1,1,1,1]]
 # @cards %{"2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8,
         # "9" => 9, "T" => 10, "J" => 11, "Q" => 12, "K" => 13, "A" => 14}
  # part 2
  @wildcards %{"2" => 2, "3" => 3, "4" => 4, "5" => 5, "6" => 6, "7" => 7, "8" => 8,
          "9" => 9, "T" => 10, "J" => 1, "Q" => 12, "K" => 13, "A" => 14}

  def parse_rank(hand_bet) do
    [hand, bet | _rest] = hand_bet
    bet_int = String.to_integer(bet)
    hand_dist = hand
    |> String.split("")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.reduce(%{}, fn card, acc ->
      Map.update(acc, card, 1, &(&1 + 1))
    end)

    # part 2: delete Js and add them to the left most value (unless there are 5 Js)
    js = Map.pop(hand_dist, "J", 0)

    rank = if elem(js, 0) < @handsize do
        max_ele = Map.delete(hand_dist, "J") |> Enum.max_by(fn x -> {elem(x, 1), Map.get(@wildcards, elem(x, 0))} end) #77JKK
        wildcard_ele = %{elem(max_ele, 0) => elem(js, 0) + elem(max_ele, 1)}
        Map.merge(Map.delete(hand_dist, "J"), wildcard_ele)
        |> Map.values()
        |> Enum.sort(&>=/2)
        |> (&Enum.find_index(Enum.reverse(@ranks), fn e -> e == &1 end)).()
      else
        6 # 5 jokers are the strongest hand
      end

    {hand, bet_int, rank}
  end

  def hand_by_val(hand) do
    hand
    |> String.split("")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(fn c -> Map.get(@wildcards, c) end)
    #|> IO.inspect(charlists: :as_lists)
  end

  def tiebreaker(hand_a, hand_b) do
    Enum.reduce_while(Enum.zip(hand_by_val(hand_a), hand_by_val(hand_b)), true, fn {a, b}, _acc ->
      cond do
       a > b ->
        {:halt, true}
       b > a ->
        {:halt, false}
       a == b ->
        {:cont, true}
      end
     end)
  end
end

IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.map(&String.split(&1, " "))
  |> Enum.map(&CamelCards.parse_rank(&1))
  |> Enum.sort(fn {a_hand, _, a_rank}, {b_hand, _, b_rank} -> if b_rank == a_rank, do: CamelCards.tiebreaker(b_hand,a_hand), else: b_rank > a_rank end)
  |> Enum.with_index(1)
  #|> IO.inspect(charlists: :as_lists, limit: :infinity)
  |> Enum.map(fn {{_h,b,_r},rr} -> b * rr end)
  |> Enum.sum
  |> IO.inspect
