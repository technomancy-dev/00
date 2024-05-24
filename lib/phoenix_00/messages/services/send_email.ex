defmodule Phoenix00.Messages.Services.SendEmail do
  alias Phoenix00.Messages.EmailRepo
  alias Phoenix00.MailMan
  alias Phoenix00.Mailer
  require Logger

  def call(%{"from" => _, "to" => _, "subject" => _, "body" => _, "text" => _} = email_req),
    do: proccess_and_send_email(email_req)

  def call(%{"from" => _, "to" => _, "subject" => _, "markdown" => _} = email_req),
    do: proccess_and_send_email(email_req)

  def call(req) do
    Logger.error("You are missing arguments to SendEmail called with:")
    Logger.error(req)
    Logger.error("Expected %{to, from, subject, body, text} or %{to, from, subject, markdown}")
    :error
  end

  defp proccess_and_send_email(email_req) do
    with {:ok, mail} <-
           email_req
           |> Map.new(fn {k, v} -> {String.to_atom(k), v} end)
           |> MailMan.letter()
           |> Mailer.deliver() do
      EmailRepo.create_email(merge_aws_with_email(mail, email_req))
    else
      _ -> :error
    end
  end

  defp merge_aws_with_email(aws, email) do
    Map.merge(email, %{
      "aws_message_id" => aws[:id],
      "status" => "pending",
      "email_id" => aws[:request_id]
    })
  end
end
