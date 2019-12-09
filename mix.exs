defmodule ElixirStatus.Mixfile do
  use Mix.Project

  def project do
    [
      app: :elixir_status,
      version: "0.0.1",
      elixir: "~> 1.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {ElixirStatus, []},
      extra_applications: [:logger, :runtime_tools]
      # applications: [
      #   :phoenix,
      #   :phoenix_html,
      #   :cowboy,
      #   :logger,
      #   :phoenix_ecto,
      #   :postgrex,
      #   :oauth2,
      #   :gettext,
      #   :appsignal,
      #   :scrivener_ecto
      # ]
    ]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_), do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:phoenix, "~> 1.4.3"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:earmark, "1.0.1"},
      {:httpoison, "~> 0.7"},
      {:phoenix_html_sanitizer, "~> 1.1.0-rc1"},
      {:oauth2, "~> 0.0"},
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, "~> 0.7"},
      {:scrivener_ecto, "~> 2.0"},
      {:calendar, "~> 0.14"},
      {:appsignal, "~> 1.11.4"},
      {:gelf_logger, "~> 0.7.3"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
