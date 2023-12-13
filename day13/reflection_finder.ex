defmodule ReflectionFinder do

  def get_hashes_horz_vert(pattern) do
    horz = get_hashes(pattern)
    vert_patt = String.split(pattern, "\n")
    |> Enum.map(&String.split(&1,""))
    |> Enum.map(&Enum.slice(&1, 1..-2))
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.join("\n")


    vert = get_hashes(vert_patt)
    {horz, vert}
  end

  def get_hashes(pattern) do
    hashed = String.split(pattern, "\n")
    |> Enum.with_index()

    hashed
    |> Enum.map(fn {_e, i} ->
      left = Enum.slice(hashed, 0..i)
      right = Enum.slice(hashed, i+1..length(hashed))
      reflect(left, right, 0)
    end)
    |> Enum.max()
  end

  def reflect([], _right, count) do
    count
  end

  def reflect(left, [], count) do
    if count > 0 do
      count + length(left)
    else
      count
    end
  end

  def reflect(left, right, count) do
    if elem(List.last(left), 0) == elem(List.first(right), 0) do
      reflect(Enum.slice(left, 0..-2), Enum.slice(right, 1..length(right)), count+1)
    else
      0
    end
  end

end

IO.read(:stdio, :eof)
  |> String.split("\n\n")
  |> Enum.map(&ReflectionFinder.get_hashes_horz_vert(&1))
  #|> IO.inspect
  |> Enum.map(fn {h, v} -> if h > v, do: h * 100, else: v end)
  |> Enum.sum
  |> IO.inspect(charlists: :as_lists, limit: :infinity)
