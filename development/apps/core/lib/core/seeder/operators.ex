defmodule Core.Seeder.Operators do
  @moduledoc """
  Seeds for `Core.Operators` context.
  """

  alias Core.{
    OperatorTypes,
    Operators,
    Repo
  }

  alias Ecto.Adapters.SQL
  alias Faker.Lorem

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE operators CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_operators()
  end

  @spec seed_operators() :: nil | Ecto.Schema.t()
  defp seed_operators do
    case Repo.aggregate(Operators, :count, :id) > 0 do
      true -> nil
      false -> insert_operators()
    end
  end

  @spec insert_operators() :: Ecto.Schema.t()
  defp insert_operators do
    operator_type_ids = Enum.map(Repo.all(OperatorTypes), &(&1.id))
    {opt_type1, opt_type2, opt_type3} = {
      Enum.at(operator_type_ids, 0),
      Enum.at(operator_type_ids, 1),
      Enum.at(operator_type_ids, 2)
    }

    [
      Repo.insert!(%Operators{
        active: random_boolean(),
        config: Map.new,
        limit: random_integer(),
        name: Lorem.sentence(),
        operator_type_id: opt_type1,
        price: random_integer(),
        priority: random_integer(),
        protocol_name: Lorem.word()
      }),
      Repo.insert!(%Operators{
        active: random_boolean(),
        config: Map.new,
        limit: random_integer(),
        name: Lorem.sentence(),
        operator_type_id: opt_type2,
        price: random_integer(),
        priority: random_integer(),
        protocol_name: Lorem.word()
      }),
      Repo.insert!(%Operators{
        active: random_boolean(),
        config: Map.new,
        limit: random_integer(),
        name: Lorem.sentence(),
        operator_type_id: opt_type3,
        price: random_integer(),
        priority: random_integer(),
        protocol_name: Lorem.word()
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
