defmodule Golf.Repo.Migrations.UniqueHoleRoundUser do
  use Ecto.Migration

  def change do

    create unique_index(:rounds_holes_users_score, [:round_id, :hole_id, :user_id])
  end
end
