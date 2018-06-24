defmodule ExchemaCoercion.Coercions.String do
  @moduledoc """
  Coercion for string and atom types
  """

  @doc """
  Coerces something to string.
  It accepts an additional argument to limit this behaviour.
  This is useful if you only want to convert certain values
  to string, for example (atoms)

  # Examples
  
      iex> ExchemaCoercion.Coercions.String.to_string(input, Exchema.Types.String,)
  """
  @spec to_string(any, Exchema.Type.t, [ExchemaCoercion.coercion], (any -> bool)) :: ExchemaCoercion.result
  def to_string(input, type, _, condition \\ fn _ -> true end)

  def to_string(input, Exchema.Types.String, _, condition) do
    case {condition.(input), String.Chars.impl_for(input)} do
      {false, _} ->
        :error
      {_, nil} ->
        :error
      {_, impl} ->
        {:ok, impl.to_string(input)}
    end
  end

  def to_string(_, _, _, _), do: :error

  @doc """
  Transforms a String to Atom

  Be careful to use that to parse external input since each atom
  will not be garbage collector and that may lead to memory leaks.

  Because of that, it allows a third argument with allowed atoms.
  """
  @spec to_atom(any, Exchema.Type.t, [ExchemaCoercion.coercion], [atom]) :: ExchemaCoercion.result
  def to_atom(input, type, _, allowed \\ [])

  def to_atom(input, Exchema.Type.Atom, _, allowed) when is_binary(input) do
    if input in Enum.map(allowed, &Atom.to_string/1) do
      {:ok, String.to_atom(input)}
    else
      :error
    end
  end

  def to_atom(_, _, _, _), do: :error
end
