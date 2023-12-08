defmodule MapNavigator do
  @end_node "ZZZ"
  @left_dir "L"

  def parse_network(network) do
    [dirs_raw, nodes | _rest] = network

    dirs = dirs_raw
    |> String.split("")
    |> Enum.filter(fn s -> String.length(s) > 0 end)
    |> Enum.map(fn x -> if x == @left_dir, do: 0, else: 1 end)

    {dirs, nodes
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " = "))
    |> Enum.map(&{Enum.at(&1, 0), parse_left_right(Enum.at(&1, 1))})
    |> Map.new}
  end

  def step(node, step_index, graph, directions) do
    if node == @end_node do
      step_index
    else
      next_dir = Enum.at(directions, (if step_index > 0, do: rem(step_index, length(directions)), else: 0) )
      next_step = Map.get(graph, node)
      step(elem(next_step, next_dir), step_index + 1, graph, directions)
    end
  end

  def parse_left_right(lr) do
    lr
    |> String.slice(1..-2)
    |> String.split(", ")
    |> (&{Enum.at(&1, 0), Enum.at(&1, 1)}).()
  end
end

IO.read(:stdio, :eof)
  |> String.split("\n\n")
  |> (&MapNavigator.parse_network(&1)).()
  |> (&MapNavigator.step("AAA", 0, elem(&1, 1), elem(&1, 0))).()
  |> IO.inspect
