defmodule Core.Notifications.PatternNotification do
  @moduledoc """
  Schema for PatternNotification.
  """

  use Core.Model

  alias Core.Notifications

  @type t :: %__MODULE__{
    id: String.t(),
    action_type: String.t(),
    full_text: String.t(),
    inserted_at: NaiveDateTime.t(),
    need_auth: boolean,
    remove_previous: boolean,
    short_text: String.t(),
    template_type: String.t(),
    time_to_live_in_sec: integer,
    title: String.t(),
    updated_at: NaiveDateTime.t(),
  }

  @allowed_params ~w(
    action_type
    full_text
    need_auth
    remove_previous
    short_text
    template_type
    time_to_live_in_sec
    title
  )a

  @required_params ~w(
    action_type
    full_text
    template_type
    title
   )a

  schema "pattern_notifications" do
    field :action_type, :string, default: "New eHealth Message", null: false
    field :full_text, :string, default: "some text", null: false
    field :need_auth, :boolean, default: nil, null: true
    field :remove_previous, :boolean, default: nil, null: true
    field :short_text, :string, default: nil, null: true
    field :template_type, :string, default: "attention", null: false
    field :time_to_live_in_sec, :integer, default: nil, null: true
    field :title, :string, default: "some text", null: false

    timestamps()
  end

  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
  end
end
