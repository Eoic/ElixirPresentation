defmodule KvStore.MixProject do
  use Mix.Project

  def project do
    [
      app: :kv_store,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {KvStore, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    []
  end
end
