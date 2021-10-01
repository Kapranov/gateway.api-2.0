defmodule Core.Notifications.Recipients do
  @moduledoc """
  Represents the recipients entity.
  """

  use Core.Model

  alias Core.Notifications.Parameters

  import Ecto.Changeset, only: [
    cast: 3,
    validate_required: 2
  ]

  @type t :: %__MODULE__{
    parameters: Parameters.t(),
    resource_id: String.t(),
    rnokpp: String.t()
  }

  @required_attrs [:rnokpp]
  @optional_attrs [:parameters, :resource_id]
  @attrs @required_attrs ++ @optional_attrs

  embedded_schema do
    embeds_one(:parameters, Parameters, on_replace: :update)

    field :resource_id, :string
    field :rnokpp, :string

    timestamps()
  end

  @doc """
  Create changeset for Recipients.
  """
  @spec changeset(t, %{atom => any}) :: Ecto.Changeset.t()
  def changeset(%__MODULE__{} = struct, attrs) do
    struct
    |> cast(attrs, @attrs)
    |> validate_required(@required_attrs)
  end
end
