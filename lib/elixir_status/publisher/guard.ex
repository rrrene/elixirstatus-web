defmodule ElixirStatus.Publisher.Guard do
  @publisher_blocked_urls Application.get_env(:elixir_status, :publisher_blocked_urls)
  @publisher_blocked_user_names Application.get_env(:elixir_status, :publisher_blocked_user_names)

  alias ElixirStatus.Publisher.SharedUrls

  def blocked?(posting, author) do
    blocked_author?(author) or blocked_posting?(posting)
  end

  def blocked_author?(author) do
    blocked_user_names = all_blocked_user_names()

    Enum.member?(blocked_user_names, author.user_name)
  end

  def blocked_posting?(posting) do
    any_blocked_urls?(posting)
  end

  defp any_blocked_urls?(posting) do
    blocked_urls = all_blocked_urls()

    posting
    |> SharedUrls.for_posting()
    |> Enum.any?(&blocked_url?(&1, blocked_urls))
  end

  defp blocked_url?(url, list_of_patterns) do
    Enum.any?(list_of_patterns, fn pattern ->
      url =~ pattern
    end)
  end

  defp all_blocked_urls do
    @publisher_blocked_urls
  end

  defp all_blocked_user_names do
    @publisher_blocked_user_names
  end
end
