defmodule ElixirStatus.UID do
  @moduledoc """
    Creates uids.
  """

  alias ElixirStatus.Repo

  def generate(model, size \\ 4) do
    new_uid(model, size, new_uid(size))
  end

  defp new_uid(size) do
    size*2
    |> :crypto.strong_rand_bytes
    |> :base64.encode_to_string
    |> to_string
    |> String.replace(~r/[\/\-\+\=]/, "")
    |> String.slice(0, size)
  end

  defp new_uid(model, size, uid) do
    case Repo.get_by(model, uid: uid) do
      nil -> uid
      _   -> new_uid(model, size, new_uid(size))
    end
  end
end
