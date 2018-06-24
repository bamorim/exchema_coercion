defmodule ExchemaCoercion.Coercions.OneOf do
  @moduledoc """
  Coercions for OneOf and OneStructOf
  """

  @one_of_types [Exchema.Types.OneOf, Exchema.Types.OneStructOf]

  @doc """
  Coerces One Of types by trying to coerce type by type and picking the
  first that matches the expected type after that.

  This is probably one case you might want to override if you have
  some external information that could speed up this procese (e.g
  a "type" field)
  """

  @spec one_of(any, Exchema.Type.t, [ExchemaCoercion.coercion]) :: ExchemaCoercion.result
  def one_of(input, {type, types}, coercions) when type in @one_of_types do
    types
    |> Stream.map(&{&1, ExchemaCoercion.coerce(input, &1, coercions)})
    |> Stream.filter(fn {t, v} -> Exchema.is?(v, t) end)
    |> Enum.at(0)
    |> case do
      nil ->
        :error

      {_, value} ->
        {:ok, value}
    end
  end

  def one_of(_, _, _), do: :error
end
