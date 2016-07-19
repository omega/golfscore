defmodule Golf.Course do
  use Golf.Web, :model

  schema "courses" do
    field :name, :string
    field :map_link, :string

    timestamps
  end

  @required_fields ~w(name map_link)
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
