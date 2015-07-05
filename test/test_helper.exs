ExUnit.start

# Create the database, run migrations, and start the test transaction.
Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(ElixirStatus.Repo)

# Remove the temp dir (we use to store avatars etc. during tests) so we can
# check if certain files are created during testing
File.rm_rf! Path.expand("../tmp/test", __DIR__)
