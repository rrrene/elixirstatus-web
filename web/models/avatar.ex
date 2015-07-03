defmodule ElixirStatus.Avatar do
  def load!(user_name, avatar_url) do
    load_image!(avatar_url, "#{avatar_path(Mix.env)}/#{user_name}.jpg")
  end

  defp load_image!(url, filename) do
    File.mkdir_p! Path.dirname(filename)

    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    File.write!(filename, body)
  end

  defp avatar_path(:test) do
    Path.expand("../../tmp/test/avatar", __DIR__)
  end

  defp avatar_path(_) do
    Path.expand("../../priv/static/images/github", __DIR__)
  end
end
