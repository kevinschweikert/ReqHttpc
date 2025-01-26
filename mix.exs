defmodule ReqHttpc.MixProject do
  use Mix.Project

  @source_url "https://github.com/derekkraan/curl_req"

  def project do
    [
      app: :req_httpc,
      name: "ReqHttpc",
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      docs: docs(),
      package: package(),
      source_url: @source_url
    ]
  end

  def application do
    [
      extra_applications: [:logger, :inets, :ssl]
    ]
  end

  defp deps do
    [
      {:req, "~> 0.5"},
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  defp docs do
    [
      main: "ReqHttpc",
      extras: ["README.md", "CHANGELOG.md"]
    ]
  end

  defp package() do
    [
      description: "Req Adapter for :httpc",
      licenses: ["MIT"],
      links: %{GitHub: @source_url},
      maintainers: ["Kevin Schweikert"]
    ]
  end
end
