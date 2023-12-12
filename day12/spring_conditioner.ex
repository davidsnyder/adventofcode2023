defmodule SpringConditioner do
  def generate_combinations(row) do
    [symbols, counts | _rest] = row
    int_counts = Enum.map(String.split(counts, ","), &(String.to_integer(&1)))
    symbols
    |> String.split("")
    |> Enum.count(fn x -> x == "?" end)
    |> (&:math.pow(2, &1)).() |> trunc() |> (&(&1-1)).()
    |> (&(0..&1)).()
    |> Enum.to_list
    |> Enum.map(&Integer.to_string(&1, 2))
    |> (&pad(&1)).()
    |> Enum.map(&String.replace(&1, "0", "."))
    |> Enum.map(&String.replace(&1, "1", "#"))
    |> Enum.map(&Enum.reduce(Enum.slice(String.split(&1,""),1..-2),symbols, fn s, acc -> String.replace(acc, "?", s, global: false) end))
    |> Enum.map(&categorize_combination/1)
    |> Enum.filter(fn l -> l == int_counts end)
  end

  def pad(list) do
    len = String.length(List.last(list))
    Enum.map(list, fn s -> diff = len - String.length(s); Enum.join([String.duplicate("0", diff),s],"") end)
  end

  def categorize_combination(combination) do
    String.split(combination, ~r/\.+/)
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(&String.length/1)
  end

end

IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.map(&String.split(&1, " "))
  |> Enum.map(&SpringConditioner.generate_combinations(&1))
  |> Enum.map(&length/1)
  |> Enum.sum
  |> IO.inspect(charlists: :as_lists, limit: :infinity)
