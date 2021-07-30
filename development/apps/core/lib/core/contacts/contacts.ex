defmodule Core.Contacts do
  @moduledoc """
  Contacts schema description
  """

  use Core.Model

  alias Core.Operators

  @type t :: %__MODULE__{
    id: String.t(),
    inserted_at: NaiveDateTime.t(),
    phone_number: String.t(),
    updated_at: NaiveDateTime.t(),
    viber_id: String.t()
  }

  @type contacts_map :: %{
    id: String.t(),
    phone_number: String.t(),
    viber_id:  String.t(),
    operator_id: String.t()
  }

  @allowed_params ~w(
    operator_id
    phone_number
    viber_id
  )a

  @required_params ~w(phone_number)a

  schema "contacts" do
    field :phone_number, :string,  null: false
    field :viber_id, :string, null: true

    belongs_to :operator, Operators, foreign_key: :operator_id, type: :binary_id

    timestamps()
  end

  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, @allowed_params)
    |> validate_required(@required_params)
    |> unique_constraint(:phone_number)
  end
end
