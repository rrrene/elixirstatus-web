defmodule ElixirStatus.Mixfile do
  use Mix.Project

  def project do
    [app: :elixir_status,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [mod: {ElixirStatus, []},
     applications: [:phoenix, :phoenix_html, :cowboy, :logger,
                    :phoenix_ecto, :mariaex, :oauth2]]
  end

  # Specifies which paths to compile per environment
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies
  #
  # Type `mix help deps` for examples and options
  defp deps do
    [
      {:cowboy, "~> 1.0"},
      {:earmark, "> 0.1.0" },
      {:httpoison, "~> 0.7"},
      {:mariaex, "~> 0.5"},
      {:phoenix, "~> 1.1"},
      {:phoenix_ecto, "~> 2.0"},
      {:phoenix_html, "~> 2.3"},
      {:phoenix_html_sanitizer, "~> 0.2.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:timex, github: "rrrene/timex"},
      {:timex_ecto, github: "rrrene/timex_ecto"},
      {:oauth2, "~> 0.3.0"},
      {:oauth, github: "tim/erlang-oauth"},
      {:extwitter, github: "rrrene/extwitter"},
      {:scrivener, "~> 1.1"}
    ]
  end
end
