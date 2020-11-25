defmodule AST do
  defstruct [:node_name, :value, :left_node, :right_node]


  @doc"""
  Print the elements of the structure
  """
    def print(ast) do
      cond do
        is_map(ast.left_node) ->
          print(ast.left_node)
          ast.node |> Atom.to_string |> IO.puts
        is_map(ast.right_node) ->
          print(ast.right_node)
          ast.node |> Atom.to_string |> IO.puts

        :true ->
          ast.node |> Atom.to_string |> IO.puts
          ast.node
      end

  end

end
