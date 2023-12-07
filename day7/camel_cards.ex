defmodule CamelCards do
  @ranks [[5], [4,1], [3,2], [3,1,1], [2,2,1], [2,1,1,1], [1,1,1,1,1]]

  def parse_rank(hand_bet) do
    [hand, bet | _rest] = hand_bet
    bet_int = String.to_integer(bet)
    rank = hand
    |> String.split("")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.reduce(%{}, fn card, acc ->
      Map.update(acc, card, 1, &(&1 + 1))
    end)
    |> Map.values()
    |> Enum.sort(&>=/2)
    |> (&Enum.find_index(Enum.reverse(@ranks), fn e -> e == &1 end)).()

    {hand, bet, rank}
  end
end

IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.map(&String.split(&1, " "))
  |> Enum.map(&CamelCards.parse_rank(&1))
  |> IO.inspect


# Five of a kind, where all five cards have the same label: AAAAA [5,0...]
# Four of a kind, where four cards have the same label and one card has a different label: AA8AA [4,1,...]
# Full house, where three cards have the same label, and the remaining two cards share a different label: 23332 [3,2..]
# Three of a kind, where three cards have the same label, and the remaining two cards are each different from any other card in the hand: TTT98 [3,1,1]
# Two pair, where two cards share one label, two other cards share a second label, and the remaining card has a third label: 23432 [2,2,1]
# One pair, where two cards share one label, and the other three cards have a different label from the pair and each other: A23A4 [2,1,1,1]
# High card, where all cards' labels are distinct: 23456 [1,1,1,1]
