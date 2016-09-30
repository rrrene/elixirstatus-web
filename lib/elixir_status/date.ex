defmodule ElixirStatus.Date do

  def diff(date1, date2) do
    date1 = date1 |> castin()
    date2 = date2 |> castin()
    case Calendar.DateTime.diff(date1, date2) do
      {:ok, seconds, _, :before} -> -1 * seconds
      {:ok, seconds, _, _} -> seconds
      _ -> nil
    end
  end

  def strftime(date, format) do
    {:ok, string} =
      date
      |> castin()
      |> Calendar.Strftime.strftime(format)
    string
  end

  # Casts Ecto.DateTimes coming into this module
  defp castin(date) do
    date
    |> Ecto.DateTime.to_erl
    |> Calendar.DateTime.from_erl!("Etc/UTC")
  end

  # Casts Calendar.DateTime leaving this module back to erl
  defp castout({:ok, date}) do
    date
    |> castout()
  end

  defp castout(date) do
    date
    |> Calendar.DateTime.to_erl
  end
end
