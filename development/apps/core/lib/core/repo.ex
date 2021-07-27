defmodule Core.Repo do
  @moduledoc """
  Core Repo.
  """

  use Ecto.Repo, otp_app: :core, adapter: Ecto.Adapters.Postgres

  @doc """
  Dynamically loads the repository url from the
  DATABASE_URL environment variable.
  """
  @spec init(:supervisor | :runtime, config :: Keyword.t()) :: {:ok, Keyword.t()} | :ignore
  def init(_, opts) do
    {:ok, Keyword.put(opts, :url, System.get_env("DATABASE_URL"))}
  end
end
