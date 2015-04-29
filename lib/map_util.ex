defmodule MapUtil do
  def from_struct_no_nil(struct) do
    Map.from_struct(struct)
    |> Enum.filter(fn ({_, val}) -> !is_nil(val) end)
    |> Enum.into(%{})
  end

  def symbolize_keys(map) do
    Enum.map(map, fn ({k, v}) -> {String.to_atom(k), v} end)
  end
end
