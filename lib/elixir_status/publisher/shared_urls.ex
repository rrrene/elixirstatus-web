defmodule ElixirStatus.Publisher.SharedUrls do
  def for_posting(posting) do
    # TODO: follow redirects
    collect_raw_urls(posting.text)
  end

  defp collect_raw_urls(text) do
    text = Earmark.to_html(text)

    ~r/href=\"([^\"]+?)\"/
    |> Regex.scan(text)
    |> Enum.map(fn([_, x]) -> x end)
  end
end