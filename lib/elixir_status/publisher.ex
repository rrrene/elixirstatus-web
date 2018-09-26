defmodule ElixirStatus.Publisher do
  @moduledoc """
    The Publisher comes into play whenever a Posting is made or updated.

    The Publisher is e.g. tasked with promoting postings on Twitter.
  """

  require Logger

  alias ElixirStatus.Persistence.Posting
  alias ElixirStatus.LinkShortener
  alias ElixirStatus.Publisher.Guard
  alias ElixirStatus.Publisher.SharedUrls

  @direct_message_recipient Application.get_env(:elixir_status, :twitter_dm_recipient)

  @doc """
    Called when a posting is created by PostingController.

    Promotes the posting on Twitter, among other things.
  """
  def after_create(new_posting, author) do
    if Guard.blocked?(new_posting, author) do
      after_create_blocked(new_posting, author)
    else
      if Guard.moderation_required?(new_posting, author) do
        after_create_moderation_required(new_posting, author)
      else
        after_create_valid(new_posting, author)
      end
    end
  end

  defp after_create_blocked(new_posting, _author) do
    new_posting
    |> create_all_short_links
    |> send_direct_message_blocked

    Posting.unpublish(new_posting)
  end

  defp after_create_moderation_required(new_posting, author) do
    new_posting
    |> create_all_short_links
    |> send_direct_message_moderation_required

    reasons = Guard.moderation_reasons(new_posting, author)

    Posting.require_moderation(new_posting, reasons)
  end

  defp after_create_valid(new_posting, author) do
    new_posting
    |> create_all_short_links
    |> send_direct_message_valid

    tweet_about_posting!(new_posting, author)
  end

  @doc """
    Called when a posting is published during moderation by PostingController.
  """
  def after_publish_moderated(posting, author) do
    tweet_about_posting!(posting, author)
  end

  @doc """
    Called when a posting is unpublished by PostingController.
  """
  def after_unpublish(posting) do
    remove_tweet!(posting)
  end

  @doc """
    Called when a posting is marked as spam during moderation by PostingController.
  """
  def after_mark_as_spam(posting) do
    remove_tweet!(posting)
  end

  @doc """
    Called when a posting is updated by PostingController.
  """
  def after_update(updated_posting, author) do
    if Guard.blocked?(updated_posting, author) do
      send_direct_message_blocked(updated_posting)
    else
      create_all_short_links(updated_posting)
    end
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
    permatitle =
      ~r/\s|\%20/
      |> Regex.split(title)
      |> Enum.join("-")
      |> String.downcase()
      |> String.replace(~r/[^a-z0-9\-]/, "")

    "#{uid}-#{permatitle}"
  end

  def tweet_about_posting!(posting, author) do
    tweet_uid = post_to_twitter(posting, author.twitter_handle)
    Posting.update_published_tweet_uid(posting, tweet_uid)
  end

  defp remove_tweet!(posting) do
    if posting.published_tweet_uid do
      spawn(fn ->
        ExTwitter.destroy_status(posting.published_tweet_uid)
      end)

      Posting.update_published_tweet_uid(posting, nil)
    end
  end

  defp create_all_short_links(posting) do
    posting
    |> SharedUrls.for_posting()
    |> Enum.map(&LinkShortener.to_uid/1)

    posting
  end

  # Sends a direct message via Twitter.
  defp send_direct_message_blocked(%ElixirStatus.Posting{title: title, permalink: permalink}) do
    text = "***BLOCKED*** #{short_title(title)} #{short_url(permalink)}"

    send_on_twitter(text, Mix.env())
  end

  def send_direct_message_moderation_required(posting) do
    text = """
    ***MODERATE***

    #{short_title(posting.title)}

    #{moderation_url(posting)}
    """

    send_on_twitter(text, Mix.env())
  end

  defp send_direct_message_valid(%ElixirStatus.Posting{title: title, permalink: permalink}) do
    text = "#{short_title(title)} #{short_url(permalink)}"

    send_on_twitter(text, Mix.env())
  end

  defp send_on_twitter(text, :prod) do
    ExTwitter.new_direct_message(@direct_message_recipient, text)
  rescue
    _ -> nil
  end

  defp send_on_twitter(tweet, _) do
    Logger.debug("send_direct_message: #{tweet}")

    nil
  end

  defp post_to_twitter(posting, author_twitter_handle) do
    posting
    |> tweet_text(author_twitter_handle)
    |> update_on_twitter(Mix.env())
  end

  defp update_on_twitter(tweet, :prod) do
    %ExTwitter.Model.Tweet{id_str: uid} = ExTwitter.update(tweet)

    uid
  end

  defp update_on_twitter(tweet, _) do
    Logger.debug("update_twitter_status: #{tweet}")

    nil
  end

  @doc """
    Returns the text for the tweet announcing the given posting.
  """
  def tweet_text(%ElixirStatus.Posting{title: title, permalink: permalink}, author_twitter_handle) do
    suffix =
      if author_twitter_handle do
        " by @#{author_twitter_handle}"
      else
        ""
      end

    # hashtag = "#elixirlang"
    hashtag = "/cc @elixirweekly"

    # 140 = magic number for "tweet text can be this long"
    #  23 = magic number for "all urls on twitter are this long"
    text =
      "#{short_title(title, 140 - String.length(suffix) - 1 - 23 - 1 - String.length(hashtag))}#{
        suffix
      } #{short_url(permalink)} #{hashtag}"

    if String.length(text) < 128 do
      "#{text} #elixirlang"
    else
      text
    end
  end

  @doc """
    Shortens a given +title+ to +max+ length.
  """
  def short_title(title, max \\ 100, delimiter \\ "...") when is_binary(title) do
    if String.length(title) <= max do
      title
    else
      max_wo_delimiter = max - String.length(delimiter)

      shortened_title =
        title
        |> String.split(" ")
        |> short_title_from_list("", max_wo_delimiter)

      "#{shortened_title}#{delimiter}"
    end
  end

  defp short_title_from_list([head | tail], "", max_length) do
    short_title_from_list(tail, head, max_length)
  end

  defp short_title_from_list([], memo, max_length) do
    if String.length(memo) >= max_length do
      String.slice(memo, 0..(max_length - 1))
    else
      memo
    end
  end

  defp short_title_from_list([head | tail], memo, max_length) do
    new_memo = "#{memo} #{head}"

    if String.length(new_memo) >= max_length do
      String.slice(memo, 0..(max_length - 1))
    else
      short_title_from_list(tail, new_memo, max_length)
    end
  end

  defp short_url(permalink) do
    uid =
      "/p/#{permalink}"
      |> ElixirStatus.URL.from_path()
      |> LinkShortener.to_uid()

    ElixirStatus.URL.from_path("/=#{uid}")
  end

  defp moderation_url(posting) do
    "/moderate/#{posting.moderation_key}"
    |> ElixirStatus.URL.from_path()
  end
end
