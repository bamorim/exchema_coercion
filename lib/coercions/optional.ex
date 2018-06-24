defmodule ExchemaCoercion.Coercions.Optional do
  @moduledoc """
  Coercion for Optional types
  """

  @doc """
  Coerces to an optional type.
  It just coerces the inner type as normal.
  """
  def optional(input, {Exchema.Types.Optional, inner}, coercions) do
    ExchemaCoercion.try_coerce(input, inner, coercions)
  end
  
  def optional(_, _, _), do: :error
end