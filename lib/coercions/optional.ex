defmodule ExchemaCoercion.Coercions.Optional do
  @moduledoc """
  Coercion for Optional types
  """

  @doc """
  Coerces to an optional type.
  It just coerces the inner type as normal, unless the inside is nil.
  """
  def optional(nil, {Exchema.Types.Optional, _}, _) do
    {:ok, nil}
  end
  def optional(input, {Exchema.Types.Optional, inner}, coercions) do
    ExchemaCoercion.try_coerce(input, inner, coercions)
  end

  def optional(_, _, _), do: :error
end
