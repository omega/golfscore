defmodule Golf.Repo.Migrations.CreateRoundUser do
  use Ecto.Migration

  def change do
    create table(:rounds_users) do
      add :round_id, references(:rounds, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:rounds_users, [:round_id])
    create index(:rounds_users, [:user_id])

  end
end
