defmodule Core.Notifications do
  @moduledoc """
  The Notifications context.
  """

  use Core.Context

  alias Core.Notifications.PatternNotification

  @typep pattern_notification_map :: %{
    id: String.t(),
    action_type: String.t(),
    full_text: String.t(),
    inserted_at: NaiveDateTime.t(),
    need_auth: boolean,
    remove_previous: boolean,
    short_text: String.t(),
    template_type: String.t(),
    time_to_live_in_sec: integer,
    title: String.t(),
    updated_at: NaiveDateTime.t(),
  }

  @doc """
  Get all PatternNotification from database
  """
  @spec list_pattern_notifications() :: result when
          result: [PatternNotification.t()] | [] | {:error, Ecto.Changeset.t()}
  def list_pattern_notifications() do
    Repo.all(PatternNotification)
  end

  @doc """
  Add PatternNotification to database
  """
  @spec create_pattern_notification(params) :: result when
          params: pattern_notification_map(),
          result: {:ok, PatternNotification.t()} | {:error, Ecto.Changeset.t()}
  def create_pattern_notification(params) do
    %PatternNotification{}
    |> PatternNotification.changeset(params)
    |> Repo.insert()
  end

  @doc """
  Delete PatternNotification by id
  """
  @spec delete(id) :: result when
          id: String.t(),
          result: {integer(), nil | [term()]}
  def delete(id) do
    from(p in PatternNotification, where: p.id == ^id)
    |> Repo.delete_all()
  end
end
