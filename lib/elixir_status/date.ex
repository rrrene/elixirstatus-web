defmodule ElixirStatus.Date do
  @seconds_per_day 24 * 60 * 60

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

  def days_ago(count) do
    Ecto.DateTime.utc()
    |> days_ago(count)
  end

  def days_ago(date, count) do
    date
    |> castin()
    |> Calendar.DateTime.subtract!(count * @seconds_per_day)
    |> castout()
  end

  # Casts Ecto.DateTimes coming into this module
  defp castin(date) do
    date
    |> Ecto.DateTime.to_erl()
    |> Calendar.DateTime.from_erl!("Etc/UTC")
  end

  # Casts Calendar.DateTime leaving this module back to erl
  defp castout({:ok, date}) do
    date
    |> castout()
  end

  defp castout(date) do
    date
    |> Calendar.DateTime.to_erl()
    |> Ecto.DateTime.cast!()
  end
end
