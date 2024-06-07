defmodule Phoenix00.Messages.Services.RecieveSns do
  # alias Phoenix00.Messages.MessageRepo
  # alias Phoenix00.Contacts
  # alias Phoenix00.Messages.EmailRepo
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
end
