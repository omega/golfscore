defmodule Golf.Round do
  use Golf.Web, :model

  schema "rounds" do
    field :date, Ecto.Date
    belongs_to :course, Golf.Course

    many_to_many :players, Golf.User, join_through: Golf.RoundUser

    timestamps
  end

  @required_fields ~w(date course_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:course_id)
  end
end
