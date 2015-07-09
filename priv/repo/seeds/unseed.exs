alias ElixirStatus.Repo
alias ElixirStatus.Posting
alias ElixirStatus.User

case Mix.env do
  :dev ->
    Repo.delete_all(Posting)
    Repo.delete_all(User)
end
