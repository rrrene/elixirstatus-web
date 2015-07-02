defmodule ViewHelper do
  def logged_in?(assigns) do
    !is_nil(assigns[:current_user])
  end
end
