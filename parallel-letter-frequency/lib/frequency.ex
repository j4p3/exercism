defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t()], pos_integer) :: map
  def frequency(texts, workers) do
    texts
    |> Enum.chunk_every(ceil(length(texts) / workers))
    |> Enum.map(&Task.async(fn -> frequency_count(&1) end))
    |> Enum.map(&Task.await/1)
    |> Enum.reduce(&Map.merge(&1, &2, fn k, v1, v2 -> v1 + v2 end))
  end

  def frequency_count(texts) do
    # @todo: merge upper/lowercase letters
    Enum.reduce(texts, %{}, fn text, acc ->
      for <<i::binary-size(1) <- String.downcase(text)>>, i in ?a..?z, reduce: acc do
        acc -> Map.update(acc, i, 1, &(&1 + 1))
      end
    end)
  end
end
