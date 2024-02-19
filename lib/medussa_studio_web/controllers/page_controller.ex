defmodule MedussaStudioWeb.PageController do
  use MedussaStudioWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def contact(conn, _params) do
    render(conn, :contact, layout: false)
  end
end
