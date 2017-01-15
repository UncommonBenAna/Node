defmodule Benanachain.Node do
  use Benanachain.Web, :model

  schema "node" do
    field :ip, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:ip])
    |> validate_required([:ip])
    |> unique_constraint(:ip)
  end
end
