defmodule Core.Repo.Migrations.CreateRegisterNotifications do
  use Ecto.Migration

  def change do
    create table(:register_notifications, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :parameters, :map, null: false, default: Map.new()
      add :recipients,  :map, null: false, default: Map.new()
      add :register_notification_id, references(:register_notifications, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :resource_id, :uuid, default: nil, null: true
      add :rnokpp, :string, default: "1234567890", null: false
       
      timestamps()
    end
  end

  def down do
    drop table(:register_notifications)
  end
end
