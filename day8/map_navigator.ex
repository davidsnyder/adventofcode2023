defmodule MapNavigator do
  #@end_node "ZZZ"
  # part 2
  @begin_node ~r/^[0-9A-Z]{2}A$/
  @end_node ~r/^[0-9A-Z]{2}Z$/
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

  def step_all_A(graph, directions) do
    Map.keys(graph)
    |> Enum.filter(&Regex.match?(@begin_node, &1))
    |> (&step(Enum.zip(&1, Stream.repeatedly(fn -> 0 end)|> Enum.take(length(&1))), graph, directions)).()
  end

  def step(nodes_and_steps, graph, directions) do
      if Enum.all?(nodes_and_steps, &Regex.match?(@end_node, elem(&1, 0))) do
      nodes_and_steps
    else
      advanced = Enum.map(nodes_and_steps, fn nas ->
        {node, step_index} = nas
        next_dir = Enum.at(directions, (if step_index > 0, do: rem(step_index, length(directions)), else: 0) )
        next_step = Map.get(graph, node)
        {elem(next_step, next_dir), step_index + 1}
      end)
      step(advanced, graph, directions)
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
  |> (&MapNavigator.step_all_A(elem(&1, 1), elem(&1, 0))).()
  |> Enum.map(&elem(&1, 1))
  |> Enum.max
  |> IO.inspect
