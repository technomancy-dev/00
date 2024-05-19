defmodule Phoenix00Web.PageController do
  alias Phoenix00.Accounts
  use Phoenix00Web, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    case Accounts.ensure_user_exists() do
      n when n > 0 ->
        conn
        |> redirect(to: ~p"/users/log_in")

      0 ->
        redirect(conn, to: ~p"/users/register")
    end
  end
end
