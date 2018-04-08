defmodule ElixirStatus.ShortLink do
  use ElixirStatus.Web, :model

  schema "short_links" do
    field(:uid, :string)
    field(:url, :string)

    timestamps
  end

  @required_fields ~w(uid url)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
