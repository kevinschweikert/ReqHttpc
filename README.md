# ReqHttpc

When you want to use the native erlang client `httpc` but want to use the comfortable and Elixir native API of `Req`.
`ReqHttp` supplies an Adapter and the optional configuration options to use `:http` in `Req`.

Install and use it like this:

```elixir
ReqHttpc.new() |> Req.get("https://example.com")
#=> %Req.Response{} 

Req.new() |> ReqHttpc.attach() |> Req.get("https://example.com")
#=> %Req.Response{}
```

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `req_httpc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:req_httpc, "~> 0.1.0"}
  ]
end
```


