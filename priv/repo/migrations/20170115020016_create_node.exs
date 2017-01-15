defmodule Benanachain.Repo.Migrations.CreateNode do
  use Ecto.Migration

  def change do
    create table(:node) do
      add :ip, :string

      timestamps()
    end
    create unique_index(:node, [:ip])

  end
end
