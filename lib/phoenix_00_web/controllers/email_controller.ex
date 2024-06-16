defmodule Phoenix00Web.EmailController do
  alias Phoenix00.Logs
  alias Phoenix00.Messages
  use Phoenix00Web, :controller

  action_fallback Phoenix00.FallbackController

  def send(conn, email) do
    record = email |> Messages.send_email()
    token = conn.assigns[:token]

    response = %{
      success: true,
      message: "Your email has successfully been queued.",
      id: record["id"]
    }

    Logs.create_log(%{
      status: 200,
      endpoint: "/api/emails",
      method: :post,
      request: email,
      response: response,
      token_id: token.id,
      email_id: record["id"]
    })

    render(conn, :index, data: response)
  end
end
