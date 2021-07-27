defmodule Core.OperatorTypes do
  @moduledoc """
  Operator_types schema description
  """

  use Core.Model

  @type t :: %__MODULE__{
    active: boolean,
    id: String.t(),
    inserted_at: NaiveDateTime.t(),
    name:  String.t(),
    priority: integer,
    updated_at: NaiveDateTime.t()
  }

  @allowed_params ~w(
    active
    name
    priority
  )a

  @required_params ~w(
    active
    name
    priority
  )a

  schema "operator_types" do
    field :active, :boolean, default: false
    field :name, :string, null: false
    field :priority, :integer

    timestamps()
  end

  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:name)
  end
end
