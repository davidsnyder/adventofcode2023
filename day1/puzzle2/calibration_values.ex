defmodule Calibrator do
  @ascii_zero 48
  @ascii_nine 57

  def word_to_num(str) do
    str
    |> String.replace(~r/(one|two|three|four|five|six|seven|eight|nine)/, &word_to_number/1)
  end

  # the trick is that for the last number, words need to match from the back. eg. "5eightwo"
  # should parse as "5eigh2" not "58wo". The easiest way to handle this is to reverse the string and the regexes
  def word_to_num_backwards(str) do
    str
    |> String.replace(~r/(eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)/, &word_to_number/1)
  end

  defp word_to_number("eno"), do: "1"
  defp word_to_number("owt"), do: "2"
  defp word_to_number("eerht"), do: "3"
  defp word_to_number("ruof"), do: "4"
  defp word_to_number("evif"), do: "5"
  defp word_to_number("xis"), do: "6"
  defp word_to_number("neves"), do: "7"
  defp word_to_number("thgie"), do: "8"
  defp word_to_number("enin"), do: "9"

  defp word_to_number("one"), do: "1"
  defp word_to_number("two"), do: "2"
  defp word_to_number("three"), do: "3"
  defp word_to_number("four"), do: "4"
  defp word_to_number("five"), do: "5"
  defp word_to_number("six"), do: "6"
  defp word_to_number("seven"), do: "7"
  defp word_to_number("eight"), do: "8"
  defp word_to_number("nine"), do: "9"

  def calibrate(value) do
    only_nums = String.to_charlist(word_to_num(value))
    |> Enum.filter(fn num -> num >= @ascii_zero and num <= @ascii_nine end)

    reversed = String.reverse(value)
    only_nums_reversed = String.to_charlist(word_to_num_backwards(reversed))
    |> Enum.filter(fn num -> num >= @ascii_zero and num <= @ascii_nine end)

    [List.first(only_nums) - @ascii_zero, List.first(only_nums_reversed) - @ascii_zero]
    |> Enum.map(&Integer.to_string/1)
    |> Enum.reduce("", fn str, acc -> acc <> str end)
  end
end

result = IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.map(&Calibrator.calibrate/1)
  |> Enum.map(&String.to_integer/1)
  |> Enum.reduce(0, &(&1 + &2))
# |> inspect(charlists: :as_lists)

#Enum.each(input, &IO.puts/1)
IO.puts(result)
