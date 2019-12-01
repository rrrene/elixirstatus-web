alias ElixirStatus.Posting
alias ElixirStatus.Repo
alias ElixirStatus.Publisher

title = "elixirstatus: Update on screendesign"
text = """
So, this is what the current state of affairs looks like.

You can follow the development of this on Github: [rrrene/elixirstatus-web](https://github.com/rrrene/elixirstatus-web)

Goto [elixirstatus.com](http://elixirstatus.com) to pre-register your GitHub account for posting.
"""
uid = ElixirStatus.UID.generate(Posting)
%Posting{user_id: 1, uid: uid, permalink: Publisher.permalink(uid, title), text: text, title: title, scheduled_at: nil, published_at: NaiveDateTime.utc_now(), public: true}
|> Repo.insert!

# ---------------------------------------------------------------------------

title = "The new, shiny Elixir Jobs"
text = """
Elixir Jobs is the best place to find, list jobs and developer community space specifically for Elixir Programming Language.

Check out our new design: http://jobs.elixirdose.com/
"""
uid = ElixirStatus.UID.generate(Posting)
%Posting{user_id: 2, uid: uid, permalink: Publisher.permalink(uid, title), text: text, title: title, scheduled_at: nil, published_at: NaiveDateTime.utc_now(), public: true}
|> Repo.insert!

# ---------------------------------------------------------------------------

title = "New project: FluxCapacitorEx"
text = """
I just recently started this `time_travel` related project, FluxCapacitorEx.

It takes both Ecto.DateTime and Erlang tuples as input and converts them to the 1950's ...
"""
uid = ElixirStatus.UID.generate(Posting)
%Posting{user_id: 7, uid: uid, permalink: Publisher.permalink(uid, title), text: text, title: title, scheduled_at: nil, published_at: NaiveDateTime.utc_now(), public: true}
|> Repo.insert!

# ---------------------------------------------------------------------------

title = "Learning Elixir is one year old today!"
text = """
It’s been one year since my first post on Learning Elixir.

I thought I would take this opportunity to look back over the last year and reflect and to look forward to the next year: http://learningelixir.joekain.com/learning-elixir-year-one-review/
"""
uid = ElixirStatus.UID.generate(Posting)
%Posting{user_id: 3, uid: uid, permalink: Publisher.permalink(uid, title), text: text, title: title, scheduled_at: nil, published_at: NaiveDateTime.utc_now(), public: true}
|> Repo.insert!

# ---------------------------------------------------------------------------

title = "Mongo.Ecto v0.1.0 released!"
text = """
Mongo.Ecto is a MongoDB adapter for Ecto.

For detailed information for the Mongo.Ecto module check out the Github repo: https://github.com/michalmuskala/mongodb_ecto
"""
uid = ElixirStatus.UID.generate(Posting)
%Posting{user_id: 4, uid: uid, permalink: Publisher.permalink(uid, title), text: text, title: title, scheduled_at: nil, published_at: NaiveDateTime.utc_now(), public: true}
|> Repo.insert!

# ---------------------------------------------------------------------------

title = "I just wrote a blog post"
text = """
This is a fake announcement by ^ this person.

***If you are him or her, you can help this project out:***

[Edit this on GitHub](https://github.com/rrrene/elixirstatus-web/edit/master/priv/repo/seeds/postings_dev.exs) to add a more convincing text!
"""
uid = ElixirStatus.UID.generate(Posting)
%Posting{user_id: 5, uid: uid, permalink: Publisher.permalink(uid, title), text: text, title: title, scheduled_at: nil, published_at: NaiveDateTime.utc_now(), public: true}
|> Repo.insert!

# ---------------------------------------------------------------------------

title = "Version 0.0.0 released"
text = """
This is a fake announcement by ^ this person.

***If you are him or her, you can help this project out:***

[Edit this on GitHub](https://github.com/rrrene/elixirstatus-web/edit/master/priv/repo/seeds/postings_dev.exs) to add a more convincing text!
"""
uid = ElixirStatus.UID.generate(Posting)
%Posting{user_id: 6, uid: uid, permalink: Publisher.permalink(uid, title), text: text, title: title, scheduled_at: nil, published_at: NaiveDateTime.utc_now(), public: true}
|> Repo.insert!

# ---------------------------------------------------------------------------

title = "I got lazy writing fake announcements ..."
text = """
This is a fake announcement by ^ this person.

***If you are him or her, you can help this project out:***

[Edit this on GitHub](https://github.com/rrrene/elixirstatus-web/edit/master/priv/repo/seeds/postings_dev.exs) to add a more convincing text!
"""
uid = ElixirStatus.UID.generate(Posting)
%Posting{user_id: 8, uid: uid, permalink: Publisher.permalink(uid, title), text: text, title: title, scheduled_at: nil, published_at: NaiveDateTime.utc_now(), public: true}
|> Repo.insert!

# ---------------------------------------------------------------------------
