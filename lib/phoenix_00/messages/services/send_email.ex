defmodule Phoenix00.Messages.Services.SendEmail do
  alias Phoenix00.Messages.EmailRepo
  alias Phoenix00.MailMan
  alias Phoenix00.Mailer
  require Logger

  def call(
        %{"from" => from, "to" => to, "subject" => subject, "body" => body, "text" => text} =
          email_req
      ) do
    with {:ok, mail} <-
           MailMan.letter(to, from, subject, body, text)
           |> Mailer.deliver() do
      # {:ok} <-
      # EmailRepo.create_email(merge_aws_with_email(mail, email_req)) do
      :ok
    else
      _ -> :error
    end
  end

  def call(req) do
    Logger.error("You are missing arguments to SendEmail called with:")
    Logger.error(req)
    Logger.error("Expected %{to, from, subject, body, text}")
    :error
  end

  defp merge_aws_with_email(aws, email) do
    Map.merge(email, %{
      "aws_message_id" => aws[:id],
      "status" => "pending",
      "email_id" => aws[:request_id]
    })
  end
end
