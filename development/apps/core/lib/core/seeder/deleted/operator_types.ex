defmodule Core.Seeder.Deleted.OperatorTypes do
  @moduledoc """
  Deleted are seeds whole an operator_types.
  """

  # alias Core.Repo
  # alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_operator_types()
  end

  @spec deleted_operator_types() :: Ecto.Schema.t()
  defp deleted_operator_types do
    # IO.puts("Deleting data on model's OperatorTypes\n")
    # SQL.query!(Repo, "TRUNCATE operator_types CASCADE;")
  end
end
