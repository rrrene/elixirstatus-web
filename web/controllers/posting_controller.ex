defmodule ElixirStatus.PostingController do
  use ElixirStatus.Web, :controller

  alias ElixirStatus.Auth
  alias ElixirStatus.Date
  alias ElixirStatus.Publisher
  alias ElixirStatus.PostingTypifier
  alias ElixirStatus.PostingUrlFinder

  @just_created_timeout       60 # seconds
  @current_posting_assign_key :posting
  @posting_filters            ~w(blog_post project_update)
  @preview_default_title "-- insert title --"
  @preview_default_text  "-- insert text --"

  plug :load_posting when action in [:edit, :update, :delete, :show]

  plug ElixirStatus.Plugs.LoggedIn when action in [:new, :create, :edit, :update, :delete]
  plug ElixirStatus.Plugs.Admin when action in [:republish, :unpublish]
  plug ElixirStatus.Plugs.SameUserOrAdmin, @current_posting_assign_key when action in [:edit, :update, :delete]

  plug :scrub_params, "posting" when action in [:create, :update]

  def index(conn, params) do
    current_user = Auth.current_user(conn)
    admin? = Auth.admin?(conn)
    page = ElixirStatus.Persistence.Posting.published(params, current_user, admin?)

    canonical_params = Enum.filter(params, fn
      {"ref", _} -> false
      {"just_signed_in", _} -> false
      _ -> true
    end)
    canonical_url = posting_url(:index, canonical_params)

    assigns =
      [
        postings: page.entries,
        page_number: page.page_number,
        total_pages: page.total_pages,
        created_posting: load_created_posting(conn),
        just_signed_in: params["just_signed_in"] == "true",
        referred_via_elixirweekly: params["ref"] == "elixirweekly",
        searching?: !is_nil(params["q"]),
        search_query: params["q"],
        current_posting_filter: params["filter"] |> nil_if_empty(),
        posting_filters: @posting_filters,
        search: params["q"] |> nil_if_empty(),
        changeset: changeset(),
        canonical_url: canonical_url,
      ]

    conn
    |> ElixirStatus.Impressionist.record("frontpage")
    |> render("index.html", assigns)
  end

  def user(conn, %{"user_name" => user_name} = params) do
    user = ElixirStatus.Persistence.User.find_by_user_name(user_name)
    page = ElixirStatus.Persistence.Posting.published_by_user(user)

    assigns =
      [
        postings: page.entries,
        page_number: page.page_number,
        total_pages: page.total_pages,
        created_posting: load_created_posting(conn),
        just_signed_in: params["just_signed_in"] == "true",
        searching?: !is_nil(params["q"]),
        search_query: params["q"],
        changeset: changeset()
      ]

    conn
    |> ElixirStatus.Impressionist.record("frontpage")
    |> render("user.html", assigns)
  end

  def new(conn, _params) do
    render(conn, "new.html", changeset: changeset())
  end

  def create(conn, %{"posting" => posting_params}) do
    posting_params =
      posting_params
      |> extract_valid_params
      |> to_create_params(conn)

    changeset = ElixirStatus.Posting.changeset(%ElixirStatus.Posting{}, posting_params)

    if changeset.valid? do
      posting = Repo.insert!(changeset)
      current_user = Auth.current_user(conn)

      Publisher.after_create(posting, current_user.twitter_handle)

      conn
      |> put_session(:created_posting_uid, posting.uid)
      |> redirect(to: posting_path(conn, :index))
    else
      render(conn, "new.html", changeset: changeset)
    end
  end

  def preview(conn, params) do
    render(conn, "preview.html",
            layout: {ElixirStatus.LayoutView, "blank.html"},
            posting: %ElixirStatus.Posting{
                      title: default(params["title"], @preview_default_title),
                      text: default(params["text"], @preview_default_text)
                    })
  end

  def show(conn, %{"permalink" => _}) do
    show(conn, %{"id" => current_posting(conn)})
  end

  def show(conn, %{"id" => _}) do
    posting = current_posting(conn)

    assigns =
      [
        posting: posting,
        created_posting: load_created_posting(conn),
        prev_posting: load_prev_posting(posting),
        next_posting: load_next_posting(posting)
      ]

    conn
    |> ElixirStatus.Impressionist.record("detail", "posting", posting.uid)
    |> render("show.html", assigns)
  end

  def edit(conn, %{"permalink" => _}) do
    edit(conn, %{"id" => current_posting(conn)})
  end

  def edit(conn, %{"id" => _}) do
    posting = current_posting(conn)
    changeset = ElixirStatus.Posting.changeset(posting)
    render(conn, "edit.html", posting: posting, changeset: changeset)
  end

  def update(conn, %{"id" => id, "posting" => original_params}) do
    posting = Repo.get!(ElixirStatus.Posting, id)
    posting_params = original_params |> extract_valid_params
    changeset = ElixirStatus.Posting.changeset(posting, posting_params)

    if changeset.valid? do
      Repo.update!(changeset)
      |> Publisher.after_update

      conn
      |> put_flash(:info, "Posting updated successfully.")
      |> redirect(to: posting_path(conn, :index))
    else
      render(conn, "edit.html", posting: posting, changeset: changeset)
    end
  end

  defp changeset do
    ElixirStatus.Posting.changeset(%ElixirStatus.Posting{})
  end

  defp default(nil, value), do: value
  defp default("", value), do: value
  defp default(value, _), do: value

  def unpublish(conn, %{"id" => id}) do
    posting = ElixirStatus.Persistence.Posting.find_by_id(id)

    ElixirStatus.Persistence.Posting.unpublish(posting)
    Publisher.after_unpublish(posting)

    redirect(conn, to: posting_path(conn, :index))
  end

  def republish(conn, %{"id" => id}) do
    posting = ElixirStatus.Persistence.Posting.find_by_id(id)

    ElixirStatus.Persistence.Posting.republish(posting)
    # TODO: Publisher.after_republish(posting)

    redirect(conn, to: posting_path(conn, :index))
  end

  def delete(conn, %{"id" => id}) do
    posting = Repo.get!(ElixirStatus.Posting, id)
    Repo.delete!(posting)

    conn
    |> put_flash(:info, "Posting deleted successfully.")
    |> redirect(to: posting_path(conn, :index))
  end

  defp load_posting(conn, _) do
    posting = case conn do
      %{params: %{"id" => id}} -> ElixirStatus.Persistence.Posting.find_by_id(id)
      %{params: %{"permalink" => permalink}} -> ElixirStatus.Persistence.Posting.find_by_permalink(permalink)
      _ -> nil
    end
    if is_nil(posting) || posting.public == false do
      conn
      |> put_status(:not_found)
      |> render(ElixirStatus.ErrorView, "404.html")
      |> halt
    else
      conn
      |> assign(@current_posting_assign_key, posting)
    end
  end

  defp load_prev_posting(posting) do
    query = from p in ElixirStatus.Posting,
                  where: p.public == ^true and
                          p.published_at < ^posting.published_at,
                  order_by: [desc: :published_at],
                  limit: 1
    query |> Ecto.Query.preload(:user) |> Repo.one
  end

  defp load_next_posting(posting) do
    query = from p in ElixirStatus.Posting,
                  where: p.public == ^true and
                          p.published_at > ^posting.published_at,
                  order_by: [asc: :published_at],
                  limit: 1
    query |> Ecto.Query.preload(:user) |> Repo.one
  end

  defp load_created_posting(conn) do
    uid = get_session(conn, :created_posting_uid)
    case load_created_posting_by_uid(uid)  do
      nil ->
        conn
        |> put_session(:created_posting_uid, nil)
        nil
      posting -> posting
    end
  end

  defp load_created_posting_by_uid(nil), do: nil
  defp load_created_posting_by_uid(uid) do
    case ElixirStatus.Persistence.Posting.find_by_uid(uid) do
      nil ->
        nil
      posting ->
        seconds_since_posting = Date.diff(posting.published_at, Ecto.DateTime.utc)
        if seconds_since_posting < @just_created_timeout do
          posting
        else
          nil
        end
    end
  end

  defp current_posting(conn) do
    conn.assigns[@current_posting_assign_key]
  end

  defp extract_valid_params(%{"title" => title, "text" => text, "type" => type}) do
    %{"title" => title || "", "text" => text || "", "type" => type}
  end
  defp extract_valid_params(%{"title" => title, "text" => text}) do
    %{"title" => title || "", "text" => text || ""}
  end
  defp extract_valid_params(_) do
    %{"title" => "", "text" => ""}
  end

  defp to_create_params(params, conn) do
    uid = ElixirStatus.UID.generate(ElixirStatus.Posting)
    tmp_post =
      %ElixirStatus.Posting{title: params["title"], text: params["text"]}

    %{
      user_id: Auth.current_user(conn).id,
      uid: uid,
      permalink: Publisher.permalink(uid, params["title"]),
      text: params["text"],
      title: params["title"],
      scheduled_at: params["scheduled_at"],
      published_at: Ecto.DateTime.utc,
      public: true,
      type: PostingTypifier.run(tmp_post)["choice"] |> to_string,
      referenced_urls: PostingUrlFinder.run(tmp_post) |> Poison.encode!
    }
  end

  defp nil_if_empty(""), do: nil
  defp nil_if_empty(val), do: val
end
