defmodule ElixirStatus.Publisher do
  @moduledoc """
    The Publisher comes into play whenever a Posting is made or updated.

    He is e.g. tasked with promoting it on Twitter.
  """

  alias ElixirStatus.LinkShortener
  alias ElixirStatus.Posting

  @doc """
    Called when a posting is created by PostingController.

    Promotes the posting on Twitter, among other things.
  """
  def after_create(new_posting) do
    new_posting
      |> create_all_short_links
      |> post_to_twitter
  end

  @doc """
    Called when a posting is updated by PostingController.
  """
  def after_update(updated_posting) do
    updated_posting
      |> create_all_short_links
  end

  @doc """
    Returns a permalink consisting of an unmodified UID and a kebap-cased title.

        Publisher.permalink("aB87", "I really like this TiTlE")
        # => "aB87-i-really-like-this-title"
  """
  def permalink(_uid, nil) do
    nil
  end

  def permalink(uid, title) do
    permatitle = Regex.split(~r/\s|\%20/, title)
                  |> Enum.join("-")
                  |> String.downcase
                  |> String.replace(~r/[^a-z0-9\-]/, "")
    "#{uid}-#{permatitle}"
  end


  defp create_all_short_links(posting) do
    text = Earmark.to_html(posting.text)
    Regex.scan(~r/href=\"([^\"]+?)\"/, text)
      |> Enum.map(fn([_, x]) -> LinkShortener.to_uid(x) end)

    posting
  end

  defp post_to_twitter(posting) do
    %Posting{title: title, permalink: permalink} = posting

    "#{short_title(title)} #{short_url(permalink)} #elixirlang"
      |> update_on_twitter(Mix.env)

    posting
  end

  defp update_on_twitter(tweet, :prod) do
    ExTwitter.update(tweet)
  end

  defp update_on_twitter(tweet, _) do
    IO.inspect {:tweeting, tweet}
  end

  def short_title(title, max \\ 100, truncate_with \\ "...") do
    if String.length(title) <= max do
      title
    else
      String.slice(title, 0..max-String.length(truncate_with)-1) <> truncate_with
    end
  end

  defp short_url(permalink) do
    uid = "#{base_url}/p/#{permalink}" |> LinkShortener.to_uid
    "#{base_url}/=#{uid}"
  end

  defp base_url, do: Application.get_env(:elixir_status, :base_url)
end
