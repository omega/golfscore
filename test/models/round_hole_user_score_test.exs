defmodule Golf.RoundHoleUserScoreTest do
  use Golf.ModelCase

  alias Golf.RoundHoleUserScore

  @valid_attrs %{score: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RoundHoleUserScore.changeset(%RoundHoleUserScore{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RoundHoleUserScore.changeset(%RoundHoleUserScore{}, @invalid_attrs)
    refute changeset.valid?
  end
end
