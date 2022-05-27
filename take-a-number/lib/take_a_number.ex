defmodule TakeANumber do
  @spec start :: pid
  def start() do
    spawn(fn -> loop(0) end)
  end

  defp loop(state) do
    receive do
      :stop ->
        nil

      msg ->
        new_state = handle_msg(msg, state)
        loop(new_state)
    end
  end

  defp handle_msg({:report_state, caller}, state) do
    send(caller, state)
    state
  end

  defp handle_msg({:take_a_number, caller}, state) do
    send(caller, state + 1)
    state + 1
  end

  defp handle_msg(_, state), do: state
end
