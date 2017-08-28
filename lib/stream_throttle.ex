defmodule StreamThrottle do
  def trickle_each(stream, duration) do
    stream
    |> Stream.map(fn item -> wait_return(item, duration) end)
  end

  defp wait_return(item, duration) do
    Task.await(Task.async(fn -> :timer.sleep(duration) end))
    item
  end
end
