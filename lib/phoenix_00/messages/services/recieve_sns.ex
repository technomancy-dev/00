defmodule Phoenix00.Messages.Services.RecieveSns do
  alias Phoenix00.Messages.MessageRepo
  alias Phoenix00.Contacts
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
    with {:ok, jason} <- Jason.decode(message),
         email <- EmailRepo.get_email_by_aws_id(jason["mail"]["messageId"]),
         recipients <- Enum.map(get_recipients(jason), fn recipient -> recipient.id end) do
      update_messages(email.id, recipients, get_status_from_event_type(jason["eventType"]))
    end
  end

  def update_messages(transmission_id, recipients, status) do
    MessageRepo.update_status_by_sender_id_and_destinations(
      transmission_id,
      recipients,
      status
    )
  end

  defp get_status_from_event_type(event_type) do
    case event_type do
      "Bounce" -> "bounced"
      "Complaint" -> "complained"
      "Send" -> "sent"
      "Pending" -> "pending"
      "Delivery" -> "delivered"
    end
  end

  defp get_recipients(sns) do
    Contacts.get_recipients_by_destinations(
      Enum.map(get_recipients_by_message(sns), fn email_map ->
        case is_map(email_map) do
          true -> email_map["emailAddress"]
          false -> email_map
        end
      end)
    )
  end

  defp get_recipients_by_message(%{"eventType" => "Complaint"} = message) do
    message["complaint"]["complainedRecipients"]
  end

  defp get_recipients_by_message(%{"eventType" => "Delivery"} = message) do
    message["delivery"]["recipients"]
  end

  defp get_recipients_by_message(%{"eventType" => "Send"} = message) do
    message["mail"]["destination"]
  end

  defp get_recipients_by_message(%{"eventType" => "Bounce"} = message) do
    message["bounce"]["bouncedRecipients"]
  end

  defp get_recipients_by_message(_message) do
    []
  end
end
