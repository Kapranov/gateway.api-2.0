defmodule Core.Seeder.Repo do
  @moduledoc """
  Seeds for `Core.Seeder.Repo` repository.
  """

  @spec seed!() :: :ok
  def seed! do
    OperatorTypes.seed!()
    Operators.seed!()
    Contacts.seed!()
  end

  @spec updated!() :: :ok
  def updated! do
    Updated.Contacts.start!()
    Updated.Operators.start!()
    Updated.OperatorTypes.start!()
  end

  @spec deleted!() :: :ok
  def deleted! do
    Deleted.Contacts.start!()
    Deleted.Operators.start!()
    Deleted.OperatorTypes.start!()
  end
end
