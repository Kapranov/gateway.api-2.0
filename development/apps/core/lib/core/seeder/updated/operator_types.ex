defmodule Core.Seeder.Updated.OperatorTypes do
  @moduledoc """
  An update are seeds whole an operator_types.
  """

  alias Core.{
    OperatorTypes,
    Repo
  }

  alias Ecto.Changeset
  alias Faker.Lorem

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_operator_types()
  end

  @spec update_operator_types() :: Ecto.Schema.t()
  defp update_operator_types do
    operator_type_ids = Enum.map(Repo.all(OperatorTypes), &(&1))
    {opt_type1, opt_type2, opt_type3} = {
      Enum.at(operator_type_ids, 0),
      Enum.at(operator_type_ids, 1),
      Enum.at(operator_type_ids, 2)
    }

    changeset1 = Changeset.change(opt_type1, %{
      name: Lorem.sentence(),
      active: random_boolean(),
      priority: random_integer()
    })

    changeset2 = Changeset.change(opt_type2, %{
      name: Lorem.sentence(),
      active: random_boolean(),
      priority: random_integer()
    })

    changeset3 = Changeset.change(opt_type3, %{
      name: Lorem.sentence(),
      active: random_boolean(),
      priority: random_integer()
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
