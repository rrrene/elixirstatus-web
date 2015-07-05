defmodule ElixirStatus.Avatar do
  def load!(user_name, avatar_url) do
    load_image!(avatar_url, "#{avatar_path(user_name, Mix.env)}")
  end

  defp static_path(user_name) do
    "images/github/#{user_name}.jpg"
  end

  defp load_image!(url, filename) do
    File.mkdir_p! Path.dirname(filename)

    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    File.write!(filename, body)
  end

  defp avatar_path(user_name, :test) do
    Path.expand("../../tmp/test/#{static_path(user_name)}", __DIR__)
  end

  defp avatar_path(user_name, _) do
    Path.expand("../../priv/static/#{static_path(user_name)}", __DIR__)
  end
end
