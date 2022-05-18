defmodule Frequency do
  @doc """
  https://exercism.org/tracks/elixir/exercises/parallel-letter-frequency

  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency([], _workers), do: %{}

  def frequency(texts, workers) do
    texts
    |> Enum.chunk_every(ceil(length(texts) / workers))
    |> Enum.map(&Task.async(fn -> frequency_count(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.reduce(&Map.merge(&1, &2, fn _k, v1, v2 -> v1 + v2 end))
  end

  defp frequency_count(texts) do
    Enum.reduce(texts, %{}, fn text, acc ->
      text
      |> String.trim()
      |> String.downcase()
      |> String.replace([",", "."], "")
      |> String.replace(~r/[[:digit:]]/, "")
      |> String.codepoints()
      |> Enum.reject(&blank?/1)
      |> Enum.reduce(acc, fn char, acc ->
        Map.update(acc, char, 1, &(&1 + 1))
      end)
    end)
  end

  defp blank?(nil), do: true
  defp blank?(""), do: true
  defp blank?(val) when is_binary(val), do: String.trim(val) == ""
  defp blank?(_val), do: false
end
