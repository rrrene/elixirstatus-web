defmodule ElixirStatusModerationSample do
  def moderation_reasons(posting, author) do
    [
      String.starts_with?(posting.title, "!!! ") && "Title starts with three exclamation marks"
    ]
  end
end
