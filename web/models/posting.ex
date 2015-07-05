defmodule ElixirStatus.Posting do
  use ElixirStatus.Web, :model

  schema "postings" do
    field :uid, :string
    field :permalink, :string
    field :title, :string
    field :text, :string
    field :scheduled_at, Ecto.DateTime
    field :published_at, Ecto.DateTime
    field :public, :boolean, default: false

    timestamps

    belongs_to :user, User
  end

  @required_fields ~w(user_id uid permalink title text published_at public)
  @optional_fields ~w(scheduled_at)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:title, min: 1)
    |> validate_length(:text, min: 1)
  end
end
