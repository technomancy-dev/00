defmodule Phoenix00.Messages.Services.RecieveSns do
  alias Phoenix00.Messages.EmailRepo
  require Logger

  def call(sns) do
    recieve_sns(sns)
  end

  def recieve_sns(sns) do
    with :ok <- ExAws.SNS.verify_message(sns) do
      handle_sns(sns)
    end
  end

  def handle_sns(%{
        "Type" => "SubscriptionConfirmation",
        "TopicArn" => topic_arn,
        "Token" => token
      }) do
    ExAws.SNS.confirm_subscription(topic_arn, token, false) |> ExAws.request()
  end

  def handle_sns(%{
        "Type" => "Notification",
        "Message" => message
      }) do
    IO.inspect("HANDLE SNS")

    with {:ok, jason} <- Jason.decode(message),
         {:ok, _response} <- handle_notification_message(jason) do
      {:ok, %{success: true}}
    end
  end

  def handle_notification_message(%{"eventType" => "Send"} = message) do
    # Send events are special, the user may not use the send API and use AWS SES directly
    # within their app. Because of that we need to create the email record if it doesn't exist.
    find_or_create_email_record(message)
  end

  def handle_notification_message(message) do
    with {:ok, _} <-
           EmailRepo.get_email_by_aws_id(message["mail"]["messageId"])
           |> EmailRepo.update_email(%{
             status: get_status_from_event_type(message["eventType"])
           }) do
      {:ok, %{success: true}}
    end
  end

  defp get_status_from_event_type(event_type) do
    case event_type do
      "Bounce" -> "bounced"
      "Complain" -> "complained"
      "Send" -> "sent"
      "Pending" -> "pending"
    end
  end

  defp find_or_create_email_record(message) do
    case EmailRepo.get_email_by_aws_id(message["mail"]["messageId"]) do
      nil ->
        EmailRepo.create_email(%{
          aws_message_id: message["mail"]["messageId"],
          to: Enum.at(message["mail"]["commonHeaders"]["to"], 0),
          from: Enum.at(message["mail"]["commonHeaders"]["from"], 0),
          status: get_status_from_event_type(message["eventType"]),
          email_id: message["mail"]["messageId"]
        })

      email ->
        EmailRepo.update_email(email, %{
          status: get_status_from_event_type(message["eventType"])
        })
    end
  end
end
