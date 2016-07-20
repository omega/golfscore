defmodule Golf.Repo.Migrations.CreateHole do
  use Ecto.Migration

  def change do
    create table(:holes) do
      add :num, :integer
      add :par, :integer
      add :course_id, references(:courses, on_delete: :nothing)

      timestamps
    end
    create index(:holes, [:course_id])

  end
end
