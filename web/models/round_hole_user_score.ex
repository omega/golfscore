defmodule Golf.RoundHoleUserScore do
  use Golf.Web, :model

  schema "rounds_holes_users_score" do
    field :score, :integer
    belongs_to :round, Golf.Round
    belongs_to :user, Golf.User
    belongs_to :hole, Golf.Hole

    timestamps
  end

  @required_fields ~w(score round user hole)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
