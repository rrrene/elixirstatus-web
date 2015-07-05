ExUnit.start

# Create the database, run migrations, and start the test transaction.
Mix.Task.run "ecto.drop", ["--quiet"]
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]

ElixirStatus.Repo.insert! %ElixirStatus.User{id: 1234, user_name: "!!~test_user~!!"}


Ecto.Adapters.SQL.begin_test_transaction(ElixirStatus.Repo)

# Remove the temp dir (we use to store avatars etc. during tests) so we can
# check if certain files are created during testing
File.rm_rf! Path.expand("../tmp/test", __DIR__)
