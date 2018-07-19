defmodule ExchemaCoercion.Coercions.List do
  @moduledoc """
  Coercions for list types
  """

  alias Exchema.Types, as: T

  @doc """
  Coerce list children
  """
  @spec children(any, Exchema.Type.t, [ExchemaCoercion.coercion]) :: ExchemaCoercion.result
  def children(input, {T.List, inner}, coercions) when is_list(input) do
    { 
      :ok,
      input
      |> Enum.map(&ExchemaCoercion.coerce(&1, inner, coercions))
    }
  end
  def children(_, _, _), do: :error
end
