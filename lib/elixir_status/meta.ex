defmodule ElixirStatus.Meta do
  @moduledoc """
    Converts URLs.
  """

  @description """
    Elixir news and status updates from the community for Elixir and Phoenix
  """

  def html_title, do: @description
  def html_description, do: @description
  def rss_title, do: @description
end
