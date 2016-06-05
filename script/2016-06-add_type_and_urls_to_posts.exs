limit = 10_000

all_postings =
  ElixirStatus.PostingController.get_all(%{"page_size" => limit})
  |> Map.get(:entries)

all_postings
|> Enum.each(fn(posting) ->
    posting_params = %{
      type: ElixirStatus.PostingTypifier.run(posting)["choice"] |> to_string,
      referenced_urls: ElixirStatus.PostingUrlFinder.run(posting) |> Poison.encode!
    }
    ElixirStatus.Posting.changeset(posting, posting_params)
    |> ElixirStatus.Repo.update!
  end)
