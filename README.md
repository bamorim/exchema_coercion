# ExchemaCoercion

`ExchemaCoercion` can receive some input and coerce to a specific type.

```elixir
iex> ExchemaCoercion.coerce("2018-01-01", Exchema.Types.Date)
~D[2018-01-01]

defmodule MyStruct do
  import Exchema.Notation
  structure [
    foo: Exchema.Types.Integer,
    bar: Exchema.Types.Date
  ]
end

iex> ExchemaCoercion.coerce(%{"foo" => 1, "bar" => "2018-01-01"}, MyStruct)
%MyStruct{
  foo: 1,
  bar: ~D[2018-01-01]
}

iex> ExchemaCoercion.coerce(["1", 2, 3.0], {Exchema.Types.List, Exchema.Types.Integer})
[1,2,3]
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exchema_coercion` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:exchema_coercion, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/exchema_coercion](https://hexdocs.pm/exchema_coercion).

