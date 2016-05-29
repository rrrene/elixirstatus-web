defmodule ElixirStatus.PostingUrlFinder do
  alias ElixirStatus.Posting

  @link_to_github ~r/(https\:\/\/github.com\/[^\/]+\/[a-zA-Z0-9\_\-]+)/

  def run(%Posting{title: _title, text: text}) do
    Regex.run(@link_to_github, text)
    |> List.wrap
    |> Enum.uniq
  end
end
