defmodule Core.Repo.Migrations.CreatePatternNotifications do
  use Ecto.Migration

  def change do
    create table(:pattern_notifications, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :action_type, :string, default: "New eHealth Message", null: false
      add :full_text, :string, default: "some text", null: false
      add :need_auth, :boolean, default: nil, null: true
      add :remove_previous, :boolean, default: nil, null: true
      add :short_text, :string, default: nil, null: true
      add :template_type, :string, default: "attention", null: false
      add :time_to_live_in_sec, :integer, default: nil, null: true
      add :title, :string, default: "some text", null: false

      timestamps()
    end
  end

  def down do
    drop table(:pattern_notifications)
  end
end
