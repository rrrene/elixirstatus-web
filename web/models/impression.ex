defmodule ElixirStatus.Impression do
  use ElixirStatus.Web, :model

  schema "impressions" do
    field(:current_user_id, :integer)
    field(:path, :string)
    field(:context, :string)
    field(:subject_type, :string)
    field(:subject_uid, :string)
    field(:accept_language, :string)
    field(:session_hash, :string)
    field(:user_agent, :string)
    field(:remote_ip, :string)

    timestamps
  end

  @required_fields ~w(context remote_ip)
  @optional_fields ~w(current_user_id subject_type subject_uid accept_language user_agent session_hash path)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> validate_length(:context, min: 1)
    |> validate_length(:remote_ip, min: 1)
  end
end
