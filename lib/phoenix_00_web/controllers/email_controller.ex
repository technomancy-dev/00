defmodule Phoenix00Web.EmailController do
  alias Phoenix00.Logs
  alias Phoenix00.Messages
  use Phoenix00Web, :controller

  action_fallback Phoenix00.FallbackController

  def send(conn, email) do
    token = conn.assigns[:token]

    case Map.merge(email, %{"token_id" => token.id}) |> Messages.send_email() do
      {:error, reason} ->
        Logs.create_log(%{
          status: 500,
          source: "api:/api/emails",
          method: :post,
          request: email,
          response: %{error: reason},
          token_id: token.id
          # email_id: record["id"]
        })

        render(conn, :index, data: %{error: reason})

      record ->
        response = %{
          success: true,
          message: "Your email has successfully been queued.",
          id: record["id"]
        }

        Logs.create_log(%{
          status: 200,
          source: "api:/api/emails",
          method: :post,
          request: email,
          response: response,
          token_id: token.id,
          email_id: record["id"]
        })

        render(conn, :index, data: response)
    end
  end
end
