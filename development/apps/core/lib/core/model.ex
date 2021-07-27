defmodule Core.Model do
  @moduledoc """
  Extention Ecto.* for schemas
  """

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Ecto.Changeset
      import Ecto.Query

      @name __MODULE__
      @primary_key {:id, :binary_id, autogenerate: true}
    end
  end
end
