defmodule GalaxyFinder do
  @galaxy "#"
  @alldots ~r/^\.+$/
  def expand(galaxy) do
    empty_columns = galaxy
    |> Enum.map(&Enum.map(Enum.slice(String.split(&1, ""), 1..-2), fn s -> if s == @galaxy do false else true end end))
    |> Enum.reduce(fn row, acc -> Enum.map(Enum.zip(row, acc), &(elem(&1,0) and elem(&1, 1))) end)

    galaxy
    |> Enum.map(fn row -> if Regex.match?(@alldots, row), do: [row, row], else: row end)
    |> List.flatten #double empty rows
    |> Enum.map(&Enum.slice(String.split(&1, ""), 1..-2))
    |> Enum.map(&Enum.with_index/1)
    |> Enum.map(&Enum.map(&1, fn t -> if Enum.at(empty_columns, elem(t, 1)), do: [elem(t, 0), elem(t, 0)], else: elem(t, 0) end))
    |> Enum.map(&List.flatten/1)
  end

  def find_galaxies(galaxy) do
    galaxy
    |> Enum.with_index()
    |> Enum.map(&Enum.map(Enum.with_index(elem(&1, 0)), fn t -> if elem(t, 0) == @galaxy, do: {elem(&1, 1), elem(t, 1)} end))
    |> Enum.map(&Enum.filter(&1, fn s -> s != nil end))
    |> List.flatten
  end

  def permute(galaxies) do
      for e1 <- galaxies,
          e2 <- galaxies do
        {e1, e2}
      end
     |> (&Enum.reduce(&1, [], fn t, acc -> {a, b} = t; if a != b and {b, a} not in acc, do: [t | acc], else: acc end)).()
  end
end

IO.read(:stdio, :eof)
  |> String.split("\n")
  |> (&GalaxyFinder.expand(&1)).()
  |> (&GalaxyFinder.find_galaxies(&1)).()
  |> (&GalaxyFinder.permute(&1)).()
  |> length()
  |> IO.inspect(charlists: :as_lists, limit: :infinity)
