defmodule Calibrator do
  @ascii_zero 48
  @ascii_nine 57

  def calibrate(value) do
    only_nums = String.to_charlist(value)
    |> Enum.filter(fn num -> num >= @ascii_zero and num <= @ascii_nine end)

    [List.first(only_nums) - @ascii_zero, List.last(only_nums) - @ascii_zero]
    |> Enum.map(&Integer.to_string/1)
    |> Enum.reduce("", fn str, acc -> acc <> str end)
  end
end

input = IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.map(&Calibrator.calibrate/1)
  |> Enum.map(&String.to_integer/1)
  |> Enum.reduce(0, &(&1 + &2))
# |> inspect(charlists: :as_lists)


IO.puts(input)
