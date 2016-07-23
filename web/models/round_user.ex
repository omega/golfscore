defmodule Golf.RoundUser do
  use Golf.Web, :model

  schema "rounds_users" do
    belongs_to :round, Golf.Round
    belongs_to :user, Golf.User

    timestamps
  end

  @required_fields ~w(round, user)
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
