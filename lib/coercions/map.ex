defmodule ExchemaCoercion.Coercions.Map do
  @moduledoc """
  Coercion for map types.
  It can coerce keyword lists into maps and coerces key and values
  """

  import ExchemaCoercion, only: [coerce: 3]

  @doc """
  Coerces Keyword lists and maps to maps given it's value
  """
  @spec to_map(any, Exchema.Type.t, [ExchemaCoercion.coercion]) :: ExchemaCoercion.result
  def to_map(input, _, _) when not is_map(input),
    do: :error

  def to_map(input, {Exchema.Types.Map, {_key_type, _value_type}} = type, coercions) do
    {:ok, do_to_map(input, type, coercions)}
  end

  def to_map(_, _, _),
    do: :error

  @doc false
  defp do_to_map(input, {_, {key_type, value_type}}, coercions) do
    input
    |> Map.to_list
    |> Enum.map(fn {key, value} -> {
      coerce(key, key_type, coercions),
      coerce(value, value_type, coercions)
    } end)
    |> Enum.into(%{})
  end

end
