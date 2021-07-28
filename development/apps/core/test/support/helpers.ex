defmodule Core.Tests.Helpers do
  @moduledoc """
  Helpers for use in tests.
  """

  defmacro clear_config(config_path) do
    quote do
      clear_config(unquote(config_path)) do
      end
    end
  end

  defmacro clear_config(config_path, do: yield) do
    quote do
      setup do
        initial_setting = Core.Config.get(unquote(config_path))
        unquote(yield)
        on_exit(fn -> Core.Config.put(unquote(config_path), initial_setting) end)
        :ok
      end
    end
  end

  defmacro clear_config_all(config_path) do
    quote do
      clear_config_all(unquote(config_path)) do
      end
    end
  end

  defmacro clear_config_all(config_path, do: yield) do
    quote do
      setup_all do
        initial_setting = Core.Config.get(unquote(config_path))
        unquote(yield)
        on_exit(fn -> Core.Config.put(unquote(config_path), initial_setting) end)
        :ok
      end
    end
  end

  defmacro __using__(_opts) do
    quote do
      import Core.Tests.Helpers,
        only: [
          clear_config: 1,
          clear_config: 2,
          clear_config_all: 1,
          clear_config_all: 2
        ]

      @spec collect_ids([%{atom => any}]) :: list()
      def collect_ids(collection) do
        collection
        |> Enum.map(& &1.id)
        |> Enum.sort()
      end

      @spec refresh_record(map()) :: Ecto.Schema.t() | nil
      def refresh_record(%{id: id, __struct__: model} = _),
        do: refresh_record(model, %{id: id})

      @spec refresh_record(map(), map()) :: Ecto.Schema.t() | nil
      def refresh_record(model, %{id: id} = _) do
        Core.Repo.get_by(model, id: id)
      end

      @spec render_json(module(), String.t(), %{atom => any}) :: %{atom => any}
      def render_json(view, template, assigns) do
        assigns = Map.new(assigns)

        view.render(template, assigns)
        |> Jason.encode!()
        |> Jason.decode!()
      end

      @spec stringify_keys(nil) :: nil
      def stringify_keys(nil), do: nil

      @spec stringify_keys(boolean()) :: boolean()
      def stringify_keys(key) when key in [true, false], do: key

      @spec stringify_keys(atom()) :: String.t()
      def stringify_keys(key) when is_atom(key), do: Atom.to_string(key)

      @spec stringify_keys(%{atom => any}) :: %{atom => any}
      def stringify_keys(map) when is_map(map) do
        map
        |> Enum.map(fn {k, v} -> {stringify_keys(k), stringify_keys(v)} end)
        |> Enum.into(%{})
      end

      @spec stringify_keys(list()) :: list()
      def stringify_keys([head | rest] = list) when is_list(list) do
        [stringify_keys(head) | stringify_keys(rest)]
      end

      @spec stringify_keys(Keyword.t()) :: Keyword.t()
      def stringify_keys(key), do: key

      defmacro guards_config(config_path) do
        quote do
          initial_setting = Core.Config.get(config_path)

          Core.Config.put(config_path, true)
          on_exit(fn -> Core.Config.put(config_path, initial_setting) end)
        end
      end
    end
  end
end
