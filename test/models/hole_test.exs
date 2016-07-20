defmodule Golf.HoleTest do
  use Golf.ModelCase

  alias Golf.Hole

  @valid_attrs %{num: 42, par: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Hole.changeset(%Hole{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Hole.changeset(%Hole{}, @invalid_attrs)
    refute changeset.valid?
  end
end
