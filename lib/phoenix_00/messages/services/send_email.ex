defmodule Phoenix00.Messages.Services.SendEmail do
  alias Phoenix00.MailMan
  require Logger

  def call(%{"from" => _, "to" => _, "subject" => _, "html" => _} = email_req),
    do: proccess_and_send_email(email_req)

  def call(%{"from" => _, "to" => _, "subject" => _, "markdown" => _} = email_req),
    do: proccess_and_send_email(email_req)

  def call(req) do
    Logger.error("Incorrect arguments SendEmail called with:")
    Logger.error(req)
    Logger.error("Expected %{to, from, subject, html} or %{to, from, subject, markdown}")
    :error
  end

  defp proccess_and_send_email(email_req) do
    with {:ok, email} <- MailMan.letter(email_req),
         {:ok, _job} <- MailMan.send_letter(email) do
      Logger.info("Successfully queued email to: #{email_req["to"]}")
      email
    else
      {:error, error} ->
        Logger.error("Failed to queue email to: #{email_req["to"]}")
        Logger.error(error)
        {:error, error}
    end
  end
end
