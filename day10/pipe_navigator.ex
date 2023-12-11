defmodule PipeNavigator do
  @ground "."
  @startsymbol "S"
  @joints %{
    # if I am an "X" pipe, I can connect on my "E" side to one of [...], etc.
    "-" => %{"E" => ["7","-","J","S"], "S" => [], "N" => [], "W" => ["-", "F", "L","S"]},
    "|" => %{"E" => [], "S" => ["|","L","J","S"], "N" => ["|","7","F","S"], "W" => []},
    "L" => %{"E" => ["7","-","J","S"], "S" => [], "N" => ["|","7","F","S"], "W" => []},
    "F" => %{"E" => ["7","-","J","S"], "S" => ["|", "L","J","S"], "N" => [], "W" => []},
    "7" => %{"E" => [], "S" => ["|","L","J","S"], "N" => [], "W" => ["-","L","F","S"]},
    "J" => %{"E" => [], "S" => [], "N" => ["|","7","F","S"], "W" => ["-","L","F","S"]},
  }

  # HELPER FUNCTIONS

  def opposite("N") do "S" end
  def opposite("S") do "N" end
  def opposite("E") do "W" end
  def opposite("W") do "E" end

  def find_start(matrix) do
    matrix
    |> Enum.map(&Enum.find_index(&1, fn c -> c == @startsymbol end))
    |> Enum.with_index
    |> Enum.filter(fn t -> elem(t, 0) != nil end)
    |> Enum.map(fn t -> {elem(t, 1), elem(t, 0), "START"} end)
    |> List.first()
  end

  def generate_coordinates(xy_dir) do
    {x, y, _dir} = xy_dir
    [{x, y-1, "W"}, {x, y+1, "E"}, {x+1, y, "S"}, {x-1, y, "N"}]
  end

  # MAIN FUNCTIONS

  def find_loop_helper(prev_pipe, current_pipe, matrix, path) do
   # IO.inspect(path, charlists: :as_lists, limit: :infinity)
    {prev_x, prev_y, _dir} = prev_pipe
    {curr_x, curr_y, _dir} = current_pipe
    current_pipe_char = Enum.at(Enum.at(matrix, curr_x), curr_y)
    if current_pipe_char == @startsymbol do #we made a loop
      path
    else
      x_len = length(matrix)
      y_len = length(List.first(matrix))
      next_step = generate_coordinates(current_pipe)
      |> Enum.filter(fn {x, y, _dir} -> x >= 0 and x < x_len and y >= 0 and y < y_len and {x, y} != {prev_x, prev_y} end) #filter coords that are out of bounds and don't go backwards
      |> Enum.filter(fn {x, y, dir} -> next_pipe_char = Enum.at(Enum.at(matrix, x),y); next_pipe_char != @ground and Enum.member?(@joints[current_pipe_char][dir], next_pipe_char) end) # filter out coordinates that are not possible based on the pipe joint
      |> List.first
      find_loop_helper(current_pipe, next_step, matrix, path ++ [current_pipe_char]) # there's only one possible coordinate left, take a step in that direction
    end
  end

  def find_loop(matrix) do
    start = find_start(matrix)
    x_len = length(matrix)
    y_len = length(List.first(matrix))
    generate_coordinates(start)
    |> Enum.filter(fn {x, y, _dir} -> x >= 0 and x < x_len and y >= 0 and y < y_len end) #filter coords that are out of bounds
    |> Enum.filter(fn {x, y, dir} -> next_pipe_char = Enum.at(Enum.at(matrix, x), y); next_pipe_char != @ground and !Enum.empty?(@joints[next_pipe_char][opposite(dir)]) end) # filter out coordinates that are not possible based on the pipe joint
    |> Enum.map(&find_loop_helper(start, &1, matrix, [@startsymbol]))
  end

end

IO.read(:stdio, :eof)
  |> String.split("\n")
  |> Enum.map(&String.split(&1, ""))
  |> Enum.map(&Enum.slice(&1,1..-2))
  |> (&PipeNavigator.find_loop(&1)).()
  #|> IO.inspect(charlists: :as_lists, limit: :infinity)
  |> Enum.map(&length/1)
  |> Enum.map(&(div(&1, 2) + rem(&1, 2)))
  |> List.first()
  |> IO.inspect(charlists: :as_lists, limit: :infinity)
