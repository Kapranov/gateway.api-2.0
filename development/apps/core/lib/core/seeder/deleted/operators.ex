defmodule Core.Seeder.Deleted.Operators do
  @moduledoc """
  Deleted are seeds whole an operators.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_operators()
  end

  @spec deleted_operators() :: Ecto.Schema.t()
  defp deleted_operators do
    IO.puts("Deleting data on model's Operators\n")
    SQL.query!(Repo, "TRUNCATE operators CASCADE;")
  end
end
