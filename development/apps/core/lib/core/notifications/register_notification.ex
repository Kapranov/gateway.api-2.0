defmodule Core.Notifications.RegisterNotification do
  @moduledoc """
  Schema for RegisterNotification.
  """

  use Core.Model

  alias Core.{
    Notifications,
    Notifications.PatternNotification
  }

  @type t :: %__MODULE__{
    id: String.t(),
    inserted_at: NaiveDateTime.t(),
    pattern_notification_id: String.t(),
    recipients: recipients_map,
    updated_at: NaiveDateTime.t()
  }

  @type recipients_map :: %{
    id: String.t(),
    rnokpp: String.t(),
    resource_id: String.t(),
    parameters: parameters_map,
  }

  @type parameters_map :: %{
    id: String.t(),
    key: String.t(),
    value:  String.t()
  }

  @allowed_params ~w(
    pattern_notification_id
    recipients
  )a

  @required_params ~w(
    pattern_notification_id
    recipients
  )a

  schema "register_notifications" do
    field :recipients, :map, default: Map.new(), null: false

    belongs_to :pattern_notifications, PatternNotification, foreign_key: :pattern_notification_id, type: :binary_id

    timestamps()
  end

  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end
