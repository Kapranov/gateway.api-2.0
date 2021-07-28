defmodule Core.Seeder.Updated.Contacts do
  @moduledoc """
  An update are seeds whole an contacts.
  """

  alias Core.{
    Contacts,
    Operators,
    Repo
  }

  alias Ecto.Changeset
  alias Faker.Phone.Hy

  @spec start!() :: Ecto.Schema.t()
  def start! do
    update_contacts()
  end

  @spec update_contacts() :: Ecto.Schema.t()
  defp update_contacts do
    contact_ids = Enum.map(Repo.all(Contacts), &(&1))
    {contact1, contact2, contact3} = {
      Enum.at(contact_ids, 0),
      Enum.at(contact_ids, 1),
      Enum.at(contact_ids, 2)
    }

    operator_ids = Enum.map(Repo.all(Operators), &(&1.id))
    {opt1, opt2, opt3} = {
      Enum.at(operator_ids, 0),
      Enum.at(operator_ids, 1),
      Enum.at(operator_ids, 2)
    }

    changeset1 = Changeset.change(contact1, %{
      operator_id: opt3,
      phone_number: Hy.number(),
      viber_id: FlakeId.get()
    })

    changeset2 = Changeset.change(contact2, %{
      operator_id: opt1,
      phone_number: Hy.number(),
      viber_id: FlakeId.get()
    })

    changeset3 = Changeset.change(contact3, %{
      operator_id: opt2,
      phone_number: Hy.number(),
      viber_id: FlakeId.get()
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
end
