defmodule ExchemaCoercion.Coercions.DateAndTime do
  @moduledoc """
  Coercions for Date and Time types
  """

  alias Exchema.Types, as: T

  @doc """
  Converts a ISO 8601 String to a native date/time format
  """
  @spec from_iso8601(any, Exchema.Type.t(), [ExchemaCoercion.coercion()]) ::
          ExchemaCoercion.result()
  def from_iso8601(input, T.DateTime, _) when is_binary(input) do
    with {:ok, val, _} <- DateTime.from_iso8601(input) do
      {:ok, val}
    end
  end

  def from_iso8601(input, T.NaiveDateTime, _) when is_binary(input) do
    NaiveDateTime.from_iso8601(input)
  end

  def from_iso8601(input, T.Date, _) when is_binary(input) do
    Date.from_iso8601(input)
  end

  def from_iso8601(input, T.Time, _) when is_binary(input) do
    Time.from_iso8601(input)
  end

  def from_iso8601(_, _, _), do: :error

  defguard valid_time_unit(unit)
           when unit in [:second, :millisecond, :microsecond, :nanosecond] or
                  (is_integer(unit) and unit >= 1)

  @doc """
  This converts integer to datetimes (either naive and not).
  It supports a optional fourth argument to specify the unit (`:second` by default)
  """
  @spec from_epoch(any, Exchema.Type.t(), [ExchemaCoercion.coercion()], System.time_unit()) ::
          ExchemaCoercion.result()
  def from_epoch(value, type, _, unit \\ :second)

  def from_epoch(value, T.DateTime, _, unit) when valid_time_unit(unit) and is_integer(value) do
    DateTime.from_unix(value, unit)
  end

  def from_epoch(value, T.NaiveDateTime, _, unit)
      when valid_time_unit(unit) and is_integer(value) do
    value
    |> DateTime.from_unix(unit)
    |> DateTime.to_naive()
  end

  def from_epoch(_, _, _, _), do: :error

  @doc """
  Converts from types with more information to those with less
  That is, it can convert from DateTime to everything, but doesn't
  convert from anything to DateTime, so we don't assume anything.

  The hierarchy is
  DateTime > NaiveDateTime > (Date & Time)
  """
  @spec without_assumptions(any, Exchema.Type.t(), [ExchemaCoercion.coercion()]) ::
          ExchemaCoercion.result()
  def without_assumptions(%DateTime{} = input, T.NaiveDateTime, _) do
    {:ok, DateTime.to_naive(input)}
  end

  def without_assumptions(%DateTime{} = input, T.Date, _) do
    {:ok, DateTime.to_date(input)}
  end

  def without_assumptions(%DateTime{} = input, T.Time, _) do
    {:ok, DateTime.to_time(input)}
  end

  def without_assumptions(%NaiveDateTime{} = input, T.Date, _) do
    {:ok, NaiveDateTime.to_date(input)}
  end

  def without_assumptions(%NaiveDateTime{} = input, T.Time, _) do
    {:ok, NaiveDateTime.to_time(input)}
  end

  def without_assumptions(_, _, _), do: :error

  @doc """
  This creates some assumptions when converting date times.
  So if we try to convert a NaiveDateTime to a DateTime, it will
  assume UTC Time Zone. If we try to convert a Date to DateTime or
  NaiveDateTime, it will assume the beginning of the day
  """
  @spec with_assumptions(any, Exchema.Type.t(), [ExchemaCoercion.coercion()]) ::
          ExchemaCoercion.result()
  def with_assumptions(%NaiveDateTime{} = input, T.DateTime, _) do
    DateTime.from_naive(input, "Etc/UTC")
  end

  def with_assumptions(%Date{} = input, T.DateTime, _) do
    with {:ok, naive} <- with_assumptions(input, T.NaiveDateTime, []) do
      DateTime.from_naive(naive, "Etc/UTC")
    end
  end

  def with_assumptions(%Date{} = input, T.NaiveDateTime, _) do
    with date <- Date.to_erl(input) do
      NaiveDateTime.from_erl({date, {0, 0, 0}})
    end
  end

  def with_assumptions(_, _, _), do: :error
end
