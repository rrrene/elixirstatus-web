defmodule ElixirStatus.Publisher do
  @moduledoc """
    The Publisher comes into play whenever a Posting is made or updated.

    He is e.g. tasked with promoting it on Twitter.
  """

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
    # TODO: implement URL shortener
    posting
  end

  defp post_to_twitter(posting) do
    %Posting{title: title, permalink: permalink} = posting

    url = "http://elixirstatus.com/p/#{permalink}" |> short_url

    "#{short_title(title)} #{url} #elixirlang"
      |> update_on_twitter(Mix.env)

    posting
  end

  defp update_on_twitter(_tweet, :test) do
    #IO.inspect {:tweeting, tweet}
  end

  defp update_on_twitter(_tweet, _) do
    # TODO: actually tweet this
  end

  def short_title(title, max \\ 100, truncate_with \\ "...") do
    if String.length(title) <= max do
      title
    else
      String.slice(title, 0..max-String.length(truncate_with)-1) <> truncate_with
    end
  end

  defp short_url(url) do
    # TODO: implement URL shortener
    url
  end
end
