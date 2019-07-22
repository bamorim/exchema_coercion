defmodule ExchemaCoercion.Coercions.Numeric do
  @moduledoc """
  Coercion functions for numeric types
  """
  alias Exchema.Types, as: T

  @doc """
  Converts string to a numeric type.
  It is a Higher-Order-Function because it allows
  customization based on wether or not we want the
  coercion to be strict (it is, ensure there is no "garbage")

  # Examples

      iex> ExchemaCoercion.Coercions.Numeric.from_string("1a", Exchema.Types.Integer, [])
      {:ok, 1}

      iex> ExchemaCoercion.Coercions.Numeric.from_string("1a", Exchema.Types.Integer, [], :strict)
      :error

      iex> ExchemaCoercion.Coercions.Numeric.from_string("1a", Exchema.Types.Float, [])
      {:ok, 1.0}

      iex> ExchemaCoercion.Coercions.Numeric.from_string("1.5", Exchema.Types.Float, [])
      {:ok, 1.5}

      iex> ExchemaCoercion.Coercions.Numeric.from_string("1a", Exchema.Types.Float, [], :strict)
      :error

      iex> ExchemaCoercion.Coercions.Numeric.from_string("1a", Exchema.Types.Float, [], :normal)
      {:ok, 1.0}

      iex> ExchemaCoercion.Coercions.Numeric.from_string("1.5", Exchema.Types.Number, [])
      {:ok, 1.5}

      iex> ExchemaCoercion.Coercions.Numeric.from_string("1", Exchema.Types.Number, [])
      {:ok, 1}

      iex> ExchemaCoercion.Coercions.Numeric.from_string("1.5a", Exchema.Types.Number, [], :strict)
      :error
  """
  @spec from_string(any, Exchema.Type.t(), [ExchemaCoercion.coercion()], :strict | :normal) ::
          ExchemaCoercion.result()
  def from_string(value, type, _, mode \\ :normal)

  def from_string(value, _, _, mode)
      when mode not in [:strict, :normal] or not is_binary(value),
      do: :error

  def from_string(value, T.Integer, _, mode) do
    value
    |> Integer.parse()
    |> wrap_parse_result(mode)
  end

  def from_string(value, T.Float, _, mode) do
    value
    |> Float.parse()
    |> wrap_parse_result(mode)
  end

  def from_string(value, T.Number, coercions, mode) do
    case Integer.parse(value) do
      {value, "." <> _} ->
        from_string(value, T.Float, coercions, mode)

      _ ->
        from_string(value, T.Integer, coercions, mode)
    end
  end

  def from_string(_, _, _, _), do: :error

  defp wrap_parse_result({value, ""}, _), do: {:ok, value}
  defp wrap_parse_result({value, _}, :normal), do: {:ok, value}
  defp wrap_parse_result(_, _), do: :error

  @doc """
  Converts a float to intger by truncating it
  """
  @spec truncate(any, Exchema.Type.t(), [ExchemaCoercion.coercion()]) :: ExchemaCoercion.result()
  def truncate(value, T.Integer, _) when is_float(value) do
    {:ok, trunc(value)}
  end

  def truncate(_, _, _), do: :error

  @doc """
  Converts a integer to a float by multiplying by 1.0
  """
  @spec integer_as_float(any, Exchema.Type.t(), [ExchemaCoercion.coercion()]) ::
          ExchemaCoercion.result()
  def integer_as_float(value, T.Float, _) when is_integer(value) do
    {:ok, value * 1.0}
  end

  def integer_as_float(_, _, _), do: :error
end
