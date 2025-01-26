defmodule ReqHttpc do
  @moduledoc """
  Run Req requests with `:httpc`

  ## Examples

      iex> ReqHttpc.new() |> Req.get("https://example.com")
      #=> %Req.Response{} 

      iex> Req.new() |> ReqHttpc.attach() |> Req.get("https://example.com")
      #=> %Req.Response{} 

  """

  @doc """
  Calls `Req.new/0`, configures the `:httpc` adapter and sets the given `opts`
  """

  @spec new(options :: keyword()) :: Req.Request.t()
  def new(opts) do
    Req.new()
    |> attach()
    |> Req.merge(opts)
  end

  @doc """
  Configures `Req` to use `:httpc` as the request adapter and registers the configuration options. See `run_httpc/1` for possible options.
  """

  @spec attach(Req.Request.t()) :: Req.Request.t()
  def attach(req) do
    req
    |> Req.Request.register_options([:httpc_http_options, :httpc_options])
    |> Req.merge(adapter: &run_httpc/1)
  end

  @doc """
  Runs the request using the native `:inets` `:httpc` client.

  This is the default Req _adapter_. See "Adapter" section in the `Req.Request` module documentation for more information on adapters.

  ## Request Options

    * `:httpc_http_options` - See `:httpc.request/5`, type `HttpOptions`

    * `:httpc_options` - See `:httpc.request/5`, type `Options`
  """

  @spec run_httpc(Req.Request.t()) ::
          {Req.Request.t(), Req.Response.t()} | {Req.Request.t(), Exception.t()}
  def run_httpc(request) do
    Application.ensure_started(:inets)
    Application.ensure_started(:ssl)

    case :httpc.request(
           method(request),
           request(request),
           http_options(request),
           options(request)
         ) do
      {:ok, {{_protocol, status_code, _status}, header_list, body}} ->
        headers = for {name, value} <- header_list, do: {to_string(name), to_string(value)}
        response = Req.Response.new(status: status_code, body: to_string(body), headers: headers)
        {request, response}

      {:error, reason} ->
        {request, RuntimeError.exception(inspect(reason))}
    end
  end

  defp method(request), do: request.method

  defp request(%Req.Request{method: :get} = request) do
    {URI.to_string(request.url), to_httpc_headers(request.headers)}
  end

  defp request(%Req.Request{method: :post} = request) do
    {URI.to_string(request.url), to_httpc_headers(request.headers),
     request.headers["content-type"] || "text/plain", request.body}
  end

  defp http_options(%{options: %{httpc_http_options: http_options}}) do
    http_options
  end

  defp http_options(_), do: []

  defp options(%{options: %{options: options}}) do
    options
  end

  defp options(_), do: []

  defp to_httpc_headers(headers) do
    for {key, values} <- headers do
      {String.to_charlist(key), Enum.join(values, ";") |> String.to_charlist()}
    end
  end
end
