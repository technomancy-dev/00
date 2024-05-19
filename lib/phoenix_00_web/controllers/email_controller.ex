defmodule Phoenix00Web.EmailController do
  alias Phoenix00.Messages
  use Phoenix00Web, :controller

  action_fallback Phoenix00.FallbackController

  def send(
        conn,
        email
      ) do
    email |> Messages.send_email()
    render(conn, :index, email: email)
  end

  def recieve_sns(
        conn,
        sns
      ) do
    with {:ok, response} <- Messages.recieve_sns(sns) do
      render(conn, :index, %{sns: response})
    end
  end
end
