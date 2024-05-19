defmodule Phoenix00.FallbackController do
  use Phoenix.Controller

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(json: Phoenix00Web.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(403)
    |> put_view(json: Phoenix00Web.ErrorJSON)
    |> render(:"403")
  end

  def call(conn, _) do
    conn
    |> put_status(500)
    |> put_view(json: Phoenix00Web.ErrorJSON)
    |> render(:"500")
  end
end
