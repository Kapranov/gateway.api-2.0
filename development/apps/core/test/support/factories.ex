defmodule Core.Factory do
  @moduledoc """
  Factory for fixtures with ExMachina.
  """

  use ExMachina.Ecto, repo: Core.Repo

  alias Core.{
    Contacts,
    OperatorTypes,
    Operators
  }

  alias Faker.{
    Lorem,
    Phone.Hy,
    UUID
  }

  @spec operator_type_factory() :: OperatorTypes.t()
  def operator_type_factory do
    %OperatorTypes{
      name: Lorem.sentence(),
      active: random_boolean(),
      priority: random_integer()
    }
  end

  @spec operator_factory() :: Operators.t()
  def operator_factory do
    %Operators{
      active: random_boolean(),
      config: Map.new,
      limit: random_integer(),
      name: Lorem.sentence(),
      operator_types: build(:operator_type),
      price: random_integer(),
      priority: random_integer(),
      protocol_name: Lorem.word()
    }
  end

  @spec contact_factory() :: Contacts.t()
  def contact_factory do
    %Contacts{
      operator: build(:operator),
      phone_number: Hy.number(),
      viber_id: UUID.v4()
    }
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
