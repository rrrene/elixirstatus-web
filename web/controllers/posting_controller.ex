defmodule ElixirStatus.PostingController do
  use ElixirStatus.Web, :controller
  use Timex

  alias ElixirStatus.Posting

  plug :authenticate, :logged_in when action in [:create, :edit, :update, :delete]
  plug :load_posting when action in [:edit, :update, :delete, :show]
  plug :authenticate, :same_user_or_admin when action in [:edit, :update, :delete]
  plug :scrub_params, "posting" when action in [:create, :update]

  def index(conn, _params) do
    postings = Repo.all(Posting)
    render(conn, "index.html", postings: postings)
  end

  def new(conn, _params) do
    changeset = Posting.changeset(%Posting{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"posting" => posting_params}) do
    posting_params = posting_params
                      |> extract_valid_params
                      |> to_create_params(conn)
    changeset = Posting.changeset(%Posting{}, posting_params)

    if changeset.valid? do
      Repo.insert!(changeset)

      conn
        |> put_flash(:info, "Posting created successfully.")
        |> redirect(to: posting_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"permalink" => permalink}) do
    posting = Repo.get_by!(Posting, permalink: permalink)
    render(conn, "show.html", posting: posting)
  end

  def show(conn, %{"id" => id}) do
    posting = Repo.get!(Posting, id)
    render(conn, "show.html", posting: posting)
  end

  def edit(conn, %{"id" => id}) do
    posting = Repo.get!(Posting, id)
    changeset = Posting.changeset(posting)
    render(conn, "edit.html", posting: posting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "posting" => posting_params}) do
    posting = Repo.get!(Posting, id)
    posting_params = posting_params |> extract_valid_params
    changeset = Posting.changeset(posting, posting_params)

    if changeset.valid? do
      Repo.update!(changeset)

      conn
        |> put_flash(:info, "Posting updated successfully.")
        |> redirect(to: posting_path(conn, :index))
    else
      render(conn, "edit.html", posting: posting, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    posting = Repo.get!(Posting, id)
    Repo.delete!(posting)

    conn
      |> put_flash(:info, "Posting deleted successfully.")
      |> redirect(to: posting_path(conn, :index))
  end

  defp load_posting(conn, _) do
    case conn do
      %{params: %{"id" => id}} ->
        conn = assign(conn, :posting, Repo.get!(Posting, id))
      _ -> nil
    end
    conn
  end

  defp authenticate(conn, :logged_in) do
    case Auth.current_user(conn) do
      nil -> redirect(conn, to: "/") |> halt
      _   -> conn
    end
  end

  defp authenticate(conn, :same_user_or_admin) do
    if Auth.admin?(conn) || Auth.belongs_to_current_user?(conn, current_posting(conn)) do
      conn
    else
      redirect(conn, to: "/") |> halt
    end
  end

  defp current_posting(conn) do
    conn.assigns[:posting]
  end

  defp extract_valid_params(%{"title" => title, "text" => text}) do
    %{"title" => String.strip(title), "text" => String.strip(text)}
  end

  defp extract_valid_params(%{"title" => title, "text" => text, "scheduled_at" => scheduled_at}) do
    %{"title" => String.strip(title), "text" => String.strip(text), "scheduled_at" => scheduled_at}
  end

  defp extract_valid_params(_) do
    %{}
  end

  defp to_create_params(params, conn) do
    uid = generate_uid(Posting)
    %{
      user_id: Auth.current_user(conn).id,
      uid: uid,
      permalink: generate_permalink(uid, params["title"]),
      text: params["text"],
      title: params["title"],
      scheduled_at: params["scheduled_at"],
      published_at: Ecto.DateTime.utc,
      public: true
    }
  end

  defp generate_permalink(uid, title) do
    Regex.split(~r/\s|\%20/, "#{uid}-#{title}")
      |> Enum.join("-")
      |> String.downcase
  end

  defp generate_uid(model, size \\ 4) do
    new_uid(model, size, new_uid(size))
  end

  defp new_uid(size) do
    :crypto.strong_rand_bytes(size*2)
      |> :base64.encode_to_string
      |> to_string
      |> String.replace(~r/[\/\-\+]/, "")
      |> String.slice(0, size)
  end

  defp new_uid(model, size, uid) do
    case Repo.get_by(model, uid: uid) do
      nil -> uid
      _   -> new_uid(model, size, new_uid(size))
    end
  end
end
