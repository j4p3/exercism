defmodule TopSecret do
  def to_ast(string) do
    Code.string_to_quoted!(string)
  end

  def decode_secret_message_part(ast, acc) do
    case ast do
      {:def, _meta, [func_arg | _rest]} ->
        {ast, [translate_message(func_arg) | acc]}

      {:defp, _meta, [func_arg | _rest]} ->
        {ast, [translate_message(func_arg) | acc]}

      _ ->
        {ast, acc}
    end
  end

  def decode_secret_message(string) do
    # Please implement the decode_secret_message/1 function
  end

  defp translate_message(ast_node) do
    {name, _meta, args} = ast_node
    message = String.slice(Atom.to_string(name), 0..(length(args) - 1))
  end
end
