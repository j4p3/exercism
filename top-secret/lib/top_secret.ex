defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part({:def, _meta, [func_node | _rest]} = ast_node, acc) do
    {ast_node, [function_name_part(func_node) | acc]}
  end

  def decode_secret_message_part({:defp, _meta, [func_node | _rest]} = ast_node, acc) do
    {ast_node, [function_name_part(func_node) | acc]}
  end

  def decode_secret_message_part(ast_node, acc) do
    {ast_node, acc}
  end

  def decode_secret_message(string) do
    {_node, message_chunks} =
      string
      |> to_ast()
      |> Macro.prewalk([], &decode_secret_message_part/2)

    message_chunks
    |> Enum.reverse()
    |> Enum.join()
  end

  defp function_name_part({:when, _meta, [func_node | _rest]}) do
    function_name_part(func_node)
  end

  defp function_name_part({_name, _meta, nil}), do: ""

  defp function_name_part({name, _meta, args}) do
    String.slice(Atom.to_string(name), 0, length(args))
  end
end
