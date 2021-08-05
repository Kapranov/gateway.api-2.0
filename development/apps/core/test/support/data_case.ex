defmodule Core.DataCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's data layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  alias Core.Repo
  alias Ecto.Adapters.SQL.Sandbox, as: Adapter
  alias Ecto.Changeset

  using do
    quote do
      alias Core.Repo

      import Ecto
      import Ecto.{
        Changeset,
        Query
      }

      import Core.DataCase
      import Core.Factory
      use Core.Tests.Helpers
    end
  end

  setup tags do
    :ok = Adapter.checkout(Repo)

    unless tags[:async], do: Adapter.mode(Repo, {:shared, self()})

    :ok
  end

  @doc """
  A helper that transforms changeset errors into a map of messages.
  """
  @spec errors_on(Ecto.Changeset.t()) :: %{atom => any}
  def errors_on(changeset) do
    Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end
end
