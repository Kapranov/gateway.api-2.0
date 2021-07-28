defmodule Core.Seeder.Updated.Operators do
  @moduledoc """
  An update are seeds whole an operators.
  """

  alias Core.{
    Operators,
    Repo
  }

  alias Ecto.Changeset
  alias Faker.Lorem

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_operators()
  end

  @spec update_operators() :: Ecto.Schema.t()
  defp update_operators do
    operator_ids = Enum.map(Repo.all(Operators), &(&1))
    {opt1, opt2, opt3} = {
      Enum.at(operator_ids, 0),
      Enum.at(operator_ids, 1),
      Enum.at(operator_ids, 2)
    }

    changeset1 = Changeset.change(opt1, %{
      active: random_boolean(),
      config: Map.new,
      limit: random_integer(),
      name: Lorem.sentence(),
      price: random_integer(),
      priority: random_integer(),
      protocol_name: Lorem.word()
    })

    changeset2 = Changeset.change(opt2, %{
      active: random_boolean(),
      config: Map.new,
      limit: random_integer(),
      name: Lorem.sentence(),
      price: random_integer(),
      priority: random_integer(),
      protocol_name: Lorem.word()
    })

    changeset3 = Changeset.change(opt3, %{
      active: random_boolean(),
      config: Map.new,
      limit: random_integer(),
      name: Lorem.sentence(),
      price: random_integer(),
      priority: random_integer(),
      protocol_name: Lorem.word()
    })

    with {:ok, _struct} <- Repo.update(changeset1),
         {:ok, _struct} <- Repo.update(changeset2),
         {:ok, _struct} <- Repo.update(changeset3)
    do
      :ok
    else
      {:error, changeset} -> changeset
    end
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
