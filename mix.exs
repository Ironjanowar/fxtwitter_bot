defmodule FxtwitterBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :fxtwitter_bot,
      version: "0.1.0",
      elixir: "~> 1.16",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {FxtwitterBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_gram, github: "rockneurotiko/ex_gram", tag: "0.27.0"},
      {:tesla, "~> 1.2"},
      {:hackney, "~> 1.12"},
      {:jason, "~> 1.4.0"},
      {:logger_file_backend, "0.0.12"},
      {:redix, "~> 1.1"}
    ]
  end
end
