defmodule ElixirStatus.Repo do
  use Ecto.Repo, otp_app: :elixir_status
  use Scrivener, page_size: 20
end
