defmodule ElixirStatus.User do
  use ElixirStatus.Web, :model

  schema "users" do
    field :full_name, :string
    field :email, :string
    field :provider, :string
    field :user_name, :string
    field :twitter_handle, :string

    timestamps

    has_many :postings, Posting
  end

  @required_fields ~w(provider user_name)
  @optional_fields ~w(full_name twitter_handle)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If `params` are nil, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
