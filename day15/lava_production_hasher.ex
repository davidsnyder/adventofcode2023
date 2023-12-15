defmodule LavaProductionHasher do
  @is_load ~r/.*=.*/

  def hash(str) do
    String.to_charlist(str)
    |> Enum.reduce(0, fn c, acc ->
      rem((acc + c) * 17, 256)
    end)
  end

  def handle_lens(lens, lens_box) do
    if Regex.match?(@is_load, lens) do # load
      [label, focal_length | _rest] = String.split(lens, "=")
      box_num = hash(label)
      box = Map.get(lens_box, box_num, [])
      exists = Enum.find(box, fn {l, _fl} -> l == label end)
      new_box =
        if exists do
          Enum.map(box, fn {l, fl} -> if l == label, do: {label, focal_length}, else: {l, fl} end)
        else
          box ++ [{label, focal_length}]
        end
      Map.put(lens_box, box_num, new_box)
    else # unload
      label = String.split(lens, "-") |> List.first()
      box_num = hash(label)
      box = Map.get(lens_box, box_num, [])
      new_box = Enum.filter(box, fn {l, _fl} -> l != label end)
      Map.put(lens_box, box_num, new_box)
    end
  end

  def handle_lenses(lenses) do
    Enum.reduce(lenses, %{}, fn l, box -> handle_lens(l, box) end)
  end

  # power of the whole box of boxes
  def get_focusing_power(lens_box) do
    Map.to_list(lens_box)
    |> Enum.map(fn {i, lenses} -> (i+1)*power(lenses) end)
  end

  # power of a single box, e.g. Box 3: [ot 7] [ab 5] [pc 6]
  def power(lenses) do
    lenses
    |> Enum.with_index(1)
    |> Enum.map(fn {{_l, fl}, i} -> i * String.to_integer(fl) end)
    |> Enum.sum
  end

end

IO.read(:stdio, :eof)
|> String.split(",")
|> (&LavaProductionHasher.handle_lenses(&1)).()
|> (&LavaProductionHasher.get_focusing_power(&1)).()
|> Enum.sum()
|> IO.inspect(charlists: :as_lists, limit: :infinity)
