defmodule Benanachain.Event do
  use Benanachain.Web, :model

  schema "events" do
    field :owner, :string
    field :recipient, :string
    field :amount, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:owner, :recipient, :amount])
    |> validate_required([:owner, :recipient, :amount])
  end
end
