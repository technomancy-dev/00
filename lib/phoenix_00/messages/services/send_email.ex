defmodule Phoenix00.Messages.Services.SendEmail do
  alias Phoenix00.MailMan
  require Logger

  def call(%{"from" => _, "to" => _, "subject" => _, "html" => _} = email_req),
    do: proccess_and_send_email(email_req)

  def call(%{"from" => _, "to" => _, "subject" => _, "markdown" => _} = email_req),
    do: proccess_and_send_email(email_req)

  def call(req) do
    Logger.error("You are missing arguments to SendEmail called with:")
    Logger.error(req)
    Logger.error("Expected %{to, from, subject, html} or %{to, from, subject, markdown}")
    :error
  end

  defp proccess_and_send_email(email_req) do
    with {:ok, _job} <-
           email_req
           |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
           |> MailMan.letter()
           |> MailMan.enqueue_worker() do
      Logger.info("Successfully queued email to: #{email_req["to"]}")
    else
      _ ->
        Logger.error("Failed to queue email to: #{email_req["to"]}")
        :error
    end
  end
end
