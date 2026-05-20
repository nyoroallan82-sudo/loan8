defmodule Loan8Web.PageController do
  use Loan8Web, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
