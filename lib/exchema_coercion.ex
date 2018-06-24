defmodule ExchemaCoercion do
  @moduledoc """
  Automagically coercion for Exchema Types
  """

  alias Exchema.Type

  @type result :: {:ok, any} | {:error, any} | :error
  @type coercion :: (any, Type.t -> result)

  @spec coerce(any, Type.t, [coercion]) :: any
  def coerce(input, type, coercions \\ ExchemaCoercion.Coercions.all)
  def coerce(input, type, coercions) do
    case try_coerce(input, type, coercions) do
      {:ok, value} ->
        value

      _ ->
        input
    end
  end
  
  @doc false
  @spec try_coerce(any, Type.t, [coercion]) :: any
  def try_coerce(_, :any, _), do: :error
  def try_coerce(input, type, coercions) do
    coercions
    |> Stream.map(&apply(&1, [input, type, coercions]))
    |> Stream.filter(&is_ok?/1)
    |> Enum.at(0)
    |> case do
      {:ok, val} ->
        {:ok, val}

      _ ->
        try_coerce(input, unfold_type(type), coercions)
    end
  end

  defp is_ok?({:ok, _}), do: true
  defp is_ok?(_), do: false

  defp unfold_type({:ref, supertype, _}),
    do: normalize_type(supertype)

  defp unfold_type(type),
    do: type |> Type.resolve_type() |> normalize_type

  @spec normalize_type(Type.t) :: Type.t
  defp normalize_type({type, {}}), do: type
  defp normalize_type({type, {arg}}), do: {type, arg}
  defp normalize_type({type, args}), do: {type, args}
  defp normalize_type(type), do: type
end
