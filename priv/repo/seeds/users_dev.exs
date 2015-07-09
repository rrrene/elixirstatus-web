alias ElixirStatus.User
alias ElixirStatus.Repo

  %User{
    full_name: "test user",
    user_name: "test",
    email: "test@test.com",
    provider: "github"
  } |> Repo.insert!

  %User{
    full_name: "test user 2",
    user_name: "test 2",
    email: "test2@test.com",
    provider: "github"
  } |> Repo.insert!
