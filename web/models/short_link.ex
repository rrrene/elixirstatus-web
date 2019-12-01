defmodule ElixirStatus.ShortLink do
  use ElixirStatus.Web, :model

  schema "short_links" do
    field(:uid, :string)
    field(:url, :string)

    timestamps
  end

  @required_fields ~w(uid url)a
  @all_fields @required_fields ++ ~w()a

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @all_fields)
    |> validate_required(@required_fields)
  end
end
