defmodule Osdi.Mixfile do
  use Mix.Project

  def project do
    [
      app: :osdi,
      version: "0.1.0",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :timex],
      mod: {Osdi.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:postgrex, "~> 0.13.3"},
      {:ecto, "~> 2.2", override: true},
      {:poison, "~> 3.1"},
      {:timex, "~> 3.0"},
      {:stream_data, "~> 0.1", only: :test},
      {:shorter_maps, "~> 2.0"},
      {:ecto_enum, "~> 1.0.2", override: true}
    ]
  end
end
