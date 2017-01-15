defmodule Benanachain.EventTest do
  use Benanachain.ModelCase

  alias Benanachain.Event

  @valid_attrs %{amount: 42, owner: "some content", recipient: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end
