defmodule Golf.RoundTest do
  use Golf.ModelCase

  alias Golf.Round

  @valid_attrs %{date: "2010-04-17", "course_id": 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Round.changeset(%Round{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Round.changeset(%Round{}, @invalid_attrs)
    refute changeset.valid?
  end
end
