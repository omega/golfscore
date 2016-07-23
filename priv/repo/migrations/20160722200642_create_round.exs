defmodule Golf.Repo.Migrations.CreateRound do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :date, :date
      add :course_id, references(:courses, on_delete: :nothing)

      timestamps
    end
    create index(:rounds, [:course_id])

  end
end
