defmodule MsgGatewayWeb.OperatorsView do
  @moduledoc false

  use MsgGatewayWeb, :view

  @name __MODULE__

  def render("index.json",%{operators: operators}) do
    render_many(operators, @name, "operator.json")
  end

  def render("create.json", %{status: insert_status}) do
    %{status: insert_status}
  end

  def render("delete.json", %{status: delete_status}) do
    %{status: delete_status}
  end

  def render("operator.json", %{operators: %{operator: operator, operator_type: operator_type}}) do
    %{
      id: operator.id,
      name: operator.name,
      operator_type:
        %{id: operator_type.id,
          name: operator_type.name,
          active: operator_type.active
        },
      config: operator.config,
      priority: operator.priority,
      price: operator.price,
      limit: operator.limit,
      active: operator.active
    }
  end

  def render("show.json",%{operator: operator}) do
    %{
      id: operator.id,
      name: operator.name,
      operator_type_id: operator.operator_type_id,
      config: operator.config,
      priority: operator.priority,
      price: operator.price,
      limit: operator.limit,
      active: operator.active
    }
  end
end
