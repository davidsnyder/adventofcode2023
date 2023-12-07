defmodule SeedLocator do
  def process_row(row) do
    [name, table_str | _rest ] = row
    build_map(name, table_str)
  end

  def build_map("seeds", data) do
    String.trim(data)
    |> String.split(" ")
    |> Enum.map(&String.to_integer(&1))
    |> (&Enum.chunk_every(&1, 2, 2, :discard)).()
    |> Enum.map(fn [a, b] -> a..(a+b-1) end)
    |> List.flatten
   # |> IO.inspect(charlists: :as_lists)
    # too slow on full input |> Enum.map(&Enum.to_list(&1))
  end

  def build_map(_table_name, data) do
    data
    |> String.trim_leading()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&generate_source_dest(&1))
    # |> List.flatten
    # |> Map.new
  end

  def generate_source_dest(row) do
    [dest, source, step | _rest] = Enum.map(row, &String.to_integer/1)
    {source, dest, step}
    # too slow on full input
    # Stream.iterate({source, dest}, fn {a, b} -> {a + 1, b + 1} end)
    # |> Enum.take(step)
  end

  def jump(tupe) do
    {{source, dest, _step}, seed} = tupe
    seed + (dest - source)
  end

  def solve(seeds, tables) do
    [seed2soil, soil2fert, fert2water, water2light, light2temp, temp2humid, humid2loc | _rest] = tables
    seeds
    |> Enum.map(fn rng ->
     Enum.map(rng, fn s -> {Enum.find(seed2soil, {s, s, 0}, fn {source, _dest, step} -> s >= source and s <= (source + step) end), s} end)
    |> Enum.map(&jump(&1))
    |> Enum.map(fn s -> {Enum.find(soil2fert, {s, s, 0}, fn {source, _dest, step} -> s >= source and s <= (source + step) end), s} end)
    |> Enum.map(&jump(&1))
    |> Enum.map(fn s -> {Enum.find(fert2water, {s, s, 0}, fn {source, _dest, step} -> s >= source and s <= (source + step) end), s} end)
    |> Enum.map(&jump(&1))
    |> Enum.map(fn s -> {Enum.find(water2light, {s, s, 0}, fn {source, _dest, step} -> s >= source and s <= (source + step) end), s} end)
    |> Enum.map(&jump(&1))
    |> Enum.map(fn s -> {Enum.find(light2temp, {s, s, 0}, fn {source, _dest, step} -> s >= source and s <= (source + step) end), s} end)
    |> Enum.map(&jump(&1))
    |> Enum.map(fn s -> {Enum.find(temp2humid, {s, s, 0}, fn {source, _dest, step} -> s >= source and s <= (source + step) end), s} end)
    |> Enum.map(&jump(&1))
    |> Enum.map(fn s -> {Enum.find(humid2loc, {s, s, 0}, fn {source, _dest, step} -> s >= source and s <= (source + step) end), s} end)
    |> Enum.map(&jump(&1))
    end)
    # too slow on full input
    # |> Enum.map(&Map.get(seed2soil, &1, &1))
    # |> Enum.map(&Map.get(soil2fert, &1, &1))
    # |> Enum.map(&Map.get(fert2water, &1, &1))
    # |> Enum.map(&Map.get(water2light, &1, &1))
    # |> Enum.map(&Map.get(light2temp, &1, &1))
    # |> Enum.map(&Map.get(temp2humid, &1, &1))
    # |> Enum.map(&Map.get(humid2loc, &1, &1))
  end
end

IO.read(:stdio, :eof)
  |> String.split("\n\n")
  |> Enum.map(&String.split(&1, ":"))
  |> Enum.map(&SeedLocator.process_row(&1))
  |> (&SeedLocator.solve(hd(&1), tl(&1))).()
  |> List.flatten
  |> Enum.min
  |> IO.inspect(charlists: :as_lists)
