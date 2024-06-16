defmodule Phoenix00Web.EmailController do
  alias Phoenix00.Messages
  use Phoenix00Web, :controller

  action_fallback Phoenix00.FallbackController

  def send(conn, email) do
    email |> Messages.send_email()

    token = conn.assigns[:token]
    render(conn, :index, email: email, token: token)
  end
end
