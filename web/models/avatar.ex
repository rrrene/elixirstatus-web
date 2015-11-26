defmodule ElixirStatus.Avatar do
  def load!(user_name, avatar_url) do
    avatar_url
    |> String.replace("?v=3", "?v=3&s=64")
    |> load_image!("#{avatar_path(user_name, Mix.env)}")
  end

  defp static_path(user_name) do
    "images/github/#{user_name}.jpg"
  end

  defp load_image!(url, filename) do
    File.mkdir_p! Path.dirname(filename)

    %HTTPoison.Response{body: body} = HTTPoison.get!(url)
    File.write!(filename, body)

    after_image_load(Mix.env)
  end

  defp after_image_load(:prod) do
    spawn fn -> Mix.Tasks.Phoenix.Digest.run([]) end
  end

  defp after_image_load(_), do: nil

  defp avatar_path(user_name, :test) do
    Path.expand("../../tmp/test/#{static_path(user_name)}", __DIR__)
  end

  defp avatar_path(user_name, _) do
    Path.expand("../../priv/static/#{static_path(user_name)}", __DIR__)
  end
end
