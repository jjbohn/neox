defmodule Neox.Query do
  alias Neox.Client, as: Client

  def create(keyword), do: _create(keyword, [])
  def _create([], acc), do: acc
  def _create([head | tail], acc), do: _create(tail, acc ++ expr(create: head))

  defmacro match([{alias, {:%, _, [{_, _, [model]}, {_, _, filter}]}}]) do
    quote bind_quoted: [alias: alias, model: model, filter: filter] do
      expr(:match, to_string(alias), model, Enum.into(filter, %{}))
    end
  end

  def return([%{statement: statement, parameters: props}], key) do
    statement = [%{statement: statement <> " RETURN #{key}", parameters: props}]

    flush(statement)
  end

  def delete([%{statement: statement, parameters: props}], key) do
    statement = [%{statement: statement <> " DELETE #{key}", parameters: props}]

    flush(statement)
  end

  def flush(statements) do
    Neox.Client.post("", [body: %{statements: statements}])
  end

  def expr(:match, alias, model, filter) do
    keys = Map.keys(filter)

    param_literal = Enum.map(keys, &(to_string(&1) <> ": {props}." <> to_string(&1) <> ""))
    statement = "MATCH (" <> alias <> ":#{model} {#{Enum.join(param_literal, ", ")}})"

    [%{statement: statement, parameters: %{props: filter}}]
  end

  def expr([{action, {key, struct}} | _]) do
    alias = to_string(key)
    action = String.upcase(to_string(action))
    struct_name = List.last(String.split(to_string(struct.__struct__), "."))

    statement = action  <> "(" <> alias <> ":#{struct_name} {props})"

    [%{statement: statement, parameters: %{props: kill_nil_values(struct)}}]
  end

  defp kill_nil_values(struct) do
    Enum.into(Enum.filter(Map.from_struct(struct), fn ({_, val}) -> !is_nil(val) end), %{})
  end
end
