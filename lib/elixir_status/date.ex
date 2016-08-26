defmodule ElixirStatus.Date do
  @seconds_per_day 24 * 60 * 60

  def days_earlier(date, days) do
    date
    |> castin()
    |> Calendar.DateTime.subtract!(days * @seconds_per_day)
    |> castout()
  end

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

  defp castin(date) do
    date
    |> Ecto.DateTime.to_erl
    |> Calendar.DateTime.from_erl!("Etc/UTC")
  end

  defp castout({:ok, date}) do
    date
    |> castout()
  end

  defp castout(date) do
    date
    |> Calendar.DateTime.to_erl
  end
end
