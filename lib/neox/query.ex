defmodule Neox.Query do
  alias Neox.Client, as: Client
  import MapUtil

  def create(keyword), do: _create(keyword, [])
  def create(acc, keyword), do: _create(keyword, acc)
  def _create([], acc), do: acc
  def _create([head | tail], acc), do: _create(tail, acc ++ expr(create: head))

  defmacro match([{alias, {:%, _, [{_, _, [model | _]}, {_, _, filter}]}}]) do
    quote bind_quoted: [alias: alias, model: model, filter: filter] do
      expr(:match, to_string(alias), model, Enum.into(filter, %{}))
    end
  end

  def return([%{statement: statement, parameters: props, _struct_map: struct_map}], key) do
    statement = [%{statement: statement <> " RETURN #{key}", parameters: props}]

    response = flush(statement)

    %{"columns" => columns, "data" => data} = List.first(response.body["results"])
    Enum.map(data, &(Map.get(&1, "row")))
    |> hydrate(columns, struct_map)
  end

  def hydrate(data, columns, struct_map), do: hydrate(data, columns, struct_map, [])
  def hydrate([], _, _, acc), do: acc
  def hydrate([head | tail], columns, struct_map, acc) do
    row = hydrate_row(head, columns, struct_map)
    hydrate(tail, columns, struct_map, acc ++ [row])
  end

  def hydrate_row([row_head | row_tail], [col_head | col_tail], struct_map) do
    struct_name = Map.get(struct_map, col_head)

    struct = {:%, [], [{:__aliases__, [alias: false], [struct_name]}, {:%{}, [], symbolize_keys(row_head)}]}
             |> Code.eval_quoted
             |> elem(0)

  end

  def delete([%{statement: statement, parameters: props}], key) do
    statement = [%{statement: statement <> " DELETE #{key}", parameters: props}]

    flush(statement)
  end

  def flush(statements) do
    Client.post("", [body: %{statements: statements}])
  end

  def expr(:match, key, model, filter) do
    keys = Map.keys(filter)

    param_literal = Enum.map(keys, &(to_string(&1) <> ": {props}." <> to_string(&1) <> ""))
    statement = "MATCH (" <> key <> ":#{model} {#{Enum.join(param_literal, ", ")}})"

    [%{statement: statement, parameters: %{props: filter}, _struct_map: Map.put(%{}, key,  model)}]
  end

  def expr([{action, {key, struct}} | _]) do
    alias = to_string(key)
    action = String.upcase(to_string(action))
    struct_name = List.last(String.split(to_string(struct.__struct__), "."))

    statement = action  <> "(" <> alias <> ":#{struct_name} {props})"

    [%{statement: statement, parameters: %{props: from_struct_no_nil(struct)}}]
  end
end
