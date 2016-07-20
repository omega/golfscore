defmodule Golf.Hole do
  use Golf.Web, :model

  schema "holes" do
    field :num, :integer
    field :par, :integer
    belongs_to :course, Golf.Course

    timestamps
  end

  @required_fields ~w(num par)
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
