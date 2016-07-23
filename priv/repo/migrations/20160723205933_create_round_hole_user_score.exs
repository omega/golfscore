defmodule Golf.Repo.Migrations.CreateRoundHoleUserScore do
  use Ecto.Migration

  def change do
    create table(:rounds_holes_users_score) do
      add :score, :integer
      add :round_id, references(:rounds, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)
      add :hole_id, references(:holes, on_delete: :nothing)

      timestamps
    end
    create index(:rounds_holes_users_score, [:round_id])
    create index(:rounds_holes_users_score, [:user_id])
    create index(:rounds_holes_users_score, [:hole_id])

  end
end
