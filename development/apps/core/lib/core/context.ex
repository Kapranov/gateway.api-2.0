defmodule Core.Context do
  @moduledoc """
  Extention Ecto.* for context
  """

  defmacro __using__(_) do
    quote do
      alias Core.Repo
      alias Ecto.Adapters.SQL
      import Ecto.Query
    end
  end
end
