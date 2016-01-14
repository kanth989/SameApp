defmodule Frdapp.PageController do
  use Frdapp.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
