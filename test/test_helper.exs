ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Golf.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Golf.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Golf.Repo)

