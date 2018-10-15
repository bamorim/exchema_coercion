defmodule ExchemaCoercion.Coercions.Struct do
  @moduledoc """
  Coercions for coercion to Exchema Structs.
  """

  @doc """
  Coerces an input map as a struct given
  """
  def to_struct(input, {Exchema.Types.Struct, {struct_mod, fields}}, coercions) when is_map(input) do
    {:ok, struct(struct_mod, coerce_values(input, fields, coercions))}
  end
  def to_struct(_input, _, _), do: :error

  defp coerce_values(input, fields, coercions) do
    fields
    |> Enum.map(fn {key, type} -> {key, type, fuzzy_get(input, key)} end)
    |> Enum.map(fn {key, type, value} -> {key, ExchemaCoercion.coerce(value, type, coercions)} end)
  end

  defp fuzzy_get(map, key) do
    [& &1, &to_string/1]
    |> Enum.map(&Map.get(map, &1.(key)))
    |> Enum.filter(& &1)
    |> List.first()
  end
end
