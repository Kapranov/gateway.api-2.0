defmodule Core.Seeder.Deleted.Contacts do
  @moduledoc """
  Deleted are seeds whole an contacts.
  """

  alias Core.Repo
  alias Ecto.Adapters.SQL

  @spec start!() :: Ecto.Schema.t()
  def start! do
    deleted_contacts()
  end

  @spec deleted_contacts() :: Ecto.Schema.t()
  defp deleted_contacts do
    # IO.puts("Deleting data on model's Contacts\n")
    # SQL.query!(Repo, "TRUNCATE contacts CASCADE;")
  end
end
