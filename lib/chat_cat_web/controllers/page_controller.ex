defmodule ChatCatWeb.PageController do
  use ChatCatWeb, :controller

  def home(
        %{
          assigns: %{
            current_user: %ChatCat.Accounts.User{}
          }
        } =
          conn,
        _params
      ) do
    redirect(conn, to: ~p"/messages_live")
  end

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
end
