defmodule Core.Repo.Migrations.CreateRegisterNotifications do
  use Ecto.Migration

  def change do
    create table(:register_notifications, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :pattern_notification_id, references(:pattern_notifications, type: :uuid, on_delete: :delete_all), null: true, primary_key: false
      add :recipients,  :map, null: false, default: Map.new()
       
      timestamps()
    end
  end

  def down do
    drop table(:register_notifications)
  end
end
