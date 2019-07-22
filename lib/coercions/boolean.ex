defmodule ExchemaCoercion.Coercions.Boolean do
  @moduledoc "Coercions for Boolean type"
  alias Exchema.Types.Boolean

  @doc "Converts a string to boolean"
  @spec from_string(any, Exchema.Type.t(), [ExchemaCoercion.coercion()]) ::
          ExchemaCoercion.result()
  def from_string("false", Boolean, _), do: {:ok, false}
  def from_string("true", Boolean, _), do: {:ok, true}
  def from_string(_, _, _), do: :error

  @doc "Converts from integer, following C boolean representation"
  @spec from_int(any, Exchema.Type.t(), [ExchemaCoercion.coercion()]) :: ExchemaCoercion.result()
  def from_int(0, Boolean, _), do: {:ok, false}
  def from_int(1, Boolean, _), do: {:ok, true}
  def from_int(_, _, _), do: :error
end
