alias ElixirStatus.Posting
alias ElixirStatus.Repo
alias ElixirStatus.Publisher

uid = ElixirStatus.UID.generate(Posting)
%Posting{
  user_id: 1,
  uid: uid,
  permalink: Publisher.permalink(uid, "test post"),
  text: "bla bla bal",
  title: "test post",
  scheduled_at: Ecto.DateTime.utc,
  published_at: Ecto.DateTime.utc,
  public: true
} |> Repo.insert!

uid = ElixirStatus.UID.generate(Posting)
%Posting{
  user_id: 2,
  uid: uid,
  permalink: Publisher.permalink(uid, "test post 2"),
  text: "bla bla bal 2",
  title: "test post 2",
  scheduled_at: Ecto.DateTime.utc,
  published_at: Ecto.DateTime.utc,
  public: true
} |> Repo.insert!
