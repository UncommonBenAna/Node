defmodule Benanachain.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :owner, :string
      add :recipient, :string
      add :amount, :integer

      timestamps()
    end

  end
end
