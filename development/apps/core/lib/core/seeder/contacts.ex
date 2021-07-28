defmodule Core.Seeder.Contacts do
  @moduledoc """
  Seeds for `Core.Contacts` context.
  """

  alias Core.{
    Contacts,
    Operators,
    Repo
  }

  alias Ecto.Adapters.SQL
  alias Faker.Phone.Hy

  @spec reset_database!() :: {integer(), nil | [term()]}
  def reset_database! do
    IO.puts("Deleting old data...\n")
    SQL.query!(Repo, "TRUNCATE contacts CASCADE;")
  end

  @spec seed!() :: Ecto.Schema.t()
  def seed! do
    seed_contacts()
  end

  @spec seed_contacts() :: nil | Ecto.Schema.t()
  defp seed_contacts do
    case Repo.aggregate(Contacts, :count, :id) > 0 do
      true -> nil
      false -> insert_contacts()
    end
  end

  @spec insert_contacts() :: Ecto.Schema.t()
  defp insert_contacts do
    operator_ids = Enum.map(Repo.all(Operators), &(&1.id))
    {operator1, operator2, operator3} = {
      Enum.at(operator_ids, 0),
      Enum.at(operator_ids, 1),
      Enum.at(operator_ids, 2)
    }

    [
      Repo.insert!(%Contacts{
        operator_id: operator1,
        phone_number: Hy.number(),
        viber_id: FlakeId.get()
      }),
      Repo.insert!(%Contacts{
        operator_id: operator2,
        phone_number: Hy.number(),
        viber_id: FlakeId.get()
      }),
      Repo.insert!(%Contacts{
        operator_id: operator3,
        phone_number: Hy.number(),
        viber_id: FlakeId.get()
      })
    ]
  end
end
