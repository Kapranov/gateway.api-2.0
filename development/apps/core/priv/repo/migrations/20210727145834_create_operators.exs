defmodule Core.Repo.Migrations.CreateOperators do
  use Ecto.Migration

  def change do
    create table(:operators, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string, null: false
      add :operator_type_id, references(:operator_types, type: :uuid), null: true
      add :config, :jsonb
      add :priority, :integer
      add :price, :integer,  default: 0, null: 0
      add :limit, :integer
      add :protocol_name, :string, null: false 
      add :active, :boolean

      timestamps()
    end

    create(unique_index(:operators, [:name, :operator_type_id]))
  end

  def down do
    drop table(:operators)
  end
end
