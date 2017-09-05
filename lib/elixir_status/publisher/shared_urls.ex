defmodule ElixirStatus.Publisher.SharedUrls do
  def for_posting(posting) do
    # TODO: follow redirects
    collect_and_expand_urls(posting.text)
  end

  def collect_and_expand_urls(text) do
    text = Earmark.to_html(text)

    ~r/href=\"([^\"]+?)\"/
    |> Regex.scan(text)
    |> Enum.flat_map(fn([_, url]) ->
        expand_url(url)
      end)
  end

  def expand_url(nil), do: nil
  def expand_url(url, acc \\ []) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        acc ++ [url]
      {:ok, %HTTPoison.Response{status_code: 301, headers: headers}} ->
        headers
        |> Enum.find_value(&find_location_header/1)
        |> expand_url(acc ++ [url])
      {:ok, %HTTPoison.Response{status_code: 302, headers: headers}} ->
        headers
        |> Enum.find_value(&find_location_header/1)
        |> expand_url(acc ++ [url])
      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        nil
      {:error, %HTTPoison.Error{reason: reason}} ->
        nil
    end
  end

  defp find_location_header({"Location", location}), do: location
  defp find_location_header({"location", location}), do: location
  defp find_location_header(_), do: nil

end
