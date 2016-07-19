defmodule Golf.Repo.Migrations.CreateCourse do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :map_link, :string

      timestamps
    end

  end
end
