defmodule Core.Operators do
  @moduledoc """
  Operators schema description
  """

  use Core.Model

  alias Core.OperatorTypes

  @type t :: %__MODULE__{
    active: boolean,
    config:  map,
    id: String.t(),
    inserted_at: NaiveDateTime.t(),
    limit:  integer,
    name: String.t(),
    price: integer,
    priority: integer,
    protocol_name: String.t(),
    updated_at: NaiveDateTime.t()
  }

  @allowed_params ~w(
    active
    config
    limit
    name
    operator_type_id
    price
    priority
    protocol_name
  )a

  @required_params ~w(
    active
    config
    limit
    name
    operator_type_id
    price
    priority
    protocol_name
  )a

  schema "operators" do
    field :active, :boolean, default: false
    field :config, :map
    field :limit, :integer
    field :name, :string, null: false
    field :price, :integer,  default: 0, null: 0
    field :priority, :integer
    field :protocol_name, :string, null: false

    belongs_to :operator_types, OperatorTypes, foreign_key: :operator_type_id, type: :binary_id

    timestamps()
  end

  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:name)
    |> foreign_key_constraint(:operator_type_id)
  end
end
