defmodule ExchemaCoercion do
  @moduledoc """
  Automagically coercion for Exchema Types
  """

  alias Exchema.Type

  # Match on some concrete types
  def coerce(input, :any), do: input
  # Simple Type
  def coerce(input, type) when is_atom(type), do: coerce(input, {type, {}})
  # Parametric Types
  def coerce(input, {_, _} = type) do
    get_coercion_fun(type).(input)
  end
  # Refined Type
  def coerce(input, {:ref, supertype, _}) do
    coerce(input, supertype)
  end

  defp get_coercion_fun({type_mod, type_args} = type) do
    cond do
      :erlang.function_exported(type_mod, :__coerce__, 2) ->
        &(type_mod.__coerce__(&1, type_args))
      :erlang.function_exported(type_mod, :__coerce__, 1) ->
        &type_mod.__coerce__/1
      coercion_mod(type) ->
        &(coercion_mod(type).coerce(&1, type))
      true ->
        &(coerce(&1, Type.resolve_type(type)))
    end
  end

  defp coercion_mod(type) do
    coercion_mods
    |> Enum.find(&(&1.coerces?(type)))
  end

  defp coercion_mods do
    [
      ExchemaCoercion.Coercions
    ] |> List.flatten
  end
end