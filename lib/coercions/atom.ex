defmodule ExchemaCoercion.Coercions.Atom do
  @moduledoc """
  Coercion for atom types
  """

  @doc """
  Coerces atoms to string.

  # Examples
  
      iex> ExchemaCoercion.Coercions.String.to_string(:something, Exchema.Types.String, [])
      "something"
  """
  @spec to_string(any, Exchema.Type.t, [ExchemaCoercion.coercion]) :: ExchemaCoercion.result
  def to_string(input, type, _)

  def to_string(input, Exchema.Types.String, _) when is_atom(input) do
    {:ok, Atom.to_string(input)}
  end

  def to_string(_, _, _), do: :error

  @doc """
  Transforms a String to Atom

  Be careful to use that to parse external input since each atom
  will not be garbage collector and that may lead to memory leaks.

  Because of that, it allows a third argument with allowed atoms.
  """
  @spec from_string(any, Exchema.Type.t, [ExchemaCoercion.coercion], [atom]) :: ExchemaCoercion.result
  def from_string(input, type, _, allowed \\ [])

  def from_string(input, Exchema.Type.Atom, _, allowed) when is_binary(input) do
    if input in Enum.map(allowed, &Atom.to_string/1) do
      {:ok, String.to_atom(input)}
    else
      :error
    end
  end

  def from_string(_, _, _, _), do: :error
end
