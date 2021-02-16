defmodule PiDashWeb.PageController do
  use PiDashWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
