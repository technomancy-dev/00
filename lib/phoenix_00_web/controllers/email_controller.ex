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

  def broadcast(conn, email) do
    token = conn.assigns[:token]

    recipients = List.wrap(email["recipients"])

    results =
      Enum.map(recipients, fn recipient ->
        Map.merge(email, %{"token_id" => token.id, "to" => recipient}) |> Messages.send_email()
      end)

    {failed, successful} = Enum.split_with(results, &match?({:error, _}, &1))

    response = %{
      success: Enum.count(failed) == 0,
      successful:
        Enum.map(successful, fn record ->
          %{
            success: true,
            message: "Your email has successfully been queued.",
            id: record["id"]
          }
        end),
      errors: Enum.map(failed, fn {:error, message} -> %{error: message} end)
    }

    Logs.create_log(%{
      status:
        if Enum.count(failed) == 0 do
          200
        else
          500
        end,
      source: "api:/api/broadcasts",
      method: :post,
      request: email,
      response: response,
      token_id: token.id
    })

    render(conn, :index, data: response)
  end
end
