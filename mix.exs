defmodule Shino.MixProject do
  use Mix.Project

  def project do
    [
      app: :shino,
      version: "0.1.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:phoenix_live_view, "~> 1.0.0-rc.6"},
        {:ecto, ">= 3.11.0"},
    ]
  end
end
