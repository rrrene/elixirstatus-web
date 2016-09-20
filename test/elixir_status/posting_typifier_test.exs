defmodule ElixirStatus.PostingTypifierTest do
  use ElixirStatus.ModelCase

  alias ElixirStatus.Posting
  alias ElixirStatus.PostingTypifier

  defp assert_url_result(url, expected_result) do
    result =
      %Posting{title: "title", text: url}
      |> PostingTypifier.run()

    assert expected_result == result["choice"],
      "Expected result #{inspect expected_result} for #{url} (got #{inspect result["choice"]})"
  end

  test "recognizes VIDEO links by url" do
    [
      "https://www.youtube.com/watch?v=aZXc11eOEpI",
      "https://youtu.be/aZXc11eOEpI",
      "https://vimeo.com/131643017",
    ]
    |> Enum.each(&assert_url_result(&1, :video))
  end

  test "recognizes MEETUP links by url" do
    [
      "http://www.meetup.com/Elixir-MN/events/233255014/",
      "https://www.meetup.com//elixir-addicts/events/234038108/?showDescription=true",
      "https://www.bigmarker.com/remote-meetup/Elixir-Remote-Meetup-3#.V9su84Wi81k.twitter",
    ]
    |> Enum.each(&assert_url_result(&1, :meetup))
  end
end
