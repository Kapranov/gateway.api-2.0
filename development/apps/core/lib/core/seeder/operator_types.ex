defmodule Core.Seeder.OperatorTypes do
  @moduledoc """
  Seeds for `Core.OperatorTypes` context.
  """

  alias Core.{
    OperatorTypes,
    Repo
  }

  alias Ecto.Adapters.SQL
  alias Faker.Lorem

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE operator_types CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_operator_types()
  end

  @spec seed_operator_types() :: nil | Ecto.Schema.t()
  defp seed_operator_types do
    case Repo.aggregate(OperatorTypes, :count, :id) > 0 do
      true -> nil
      false -> insert_operator_types()
    end
  end

  @spec insert_operator_types() :: Ecto.Schema.t()
  defp insert_operator_types do
    [
      Repo.insert!(%OperatorTypes{
        name: Lorem.sentence(),
        active: random_boolean(),
        priority: random_integer()
      }),
      Repo.insert!(%OperatorTypes{
        name: Lorem.sentence(),
        active: random_boolean(),
        priority: random_integer()
      }),
      Repo.insert!(%OperatorTypes{
        name: Lorem.sentence(),
        active: random_boolean(),
        priority: random_integer()
      })
    ]
  end

  @spec random_boolean() :: boolean()
  defp random_boolean do
    data = ~W(true false)a
    Enum.random(data)
  end

  @spec random_integer() :: integer()
  defp random_integer(n \\ 99) when is_integer(n) do
    Enum.random(1..n)
  end
end
