defmodule Golf.RoundUserTest do
  use Golf.ModelCase

  alias Golf.RoundUser

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = RoundUser.changeset(%RoundUser{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = RoundUser.changeset(%RoundUser{}, @invalid_attrs)
    refute changeset.valid?
  end
end
