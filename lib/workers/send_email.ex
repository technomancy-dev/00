defmodule Phoenix00.Workers.SendEmail do
  alias Phoenix00.Contacts
  use Oban.Worker, queue: :mailer
  require Logger
  alias Phoenix00.Mailer
  alias Phoenix00.Messages

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email_args}}) do
    recipients = get_recipients(email_args)

    with email <- Mailer.from_map(email_args),
         {:ok, metadata} <- Mailer.deliver(email),
         {:ok, email} <-
           Messages.create_email(Map.merge(email_args, %{"sender_id" => metadata.id})) do
      Enum.each(recipients, fn recipient ->
        {:ok, recipient} = Contacts.create_recipient(%{destination: recipient})

        Messages.create_message(%{
          status: :sent,
          recipient: recipient.id,
          transmission: email.id
        })
      end)

      :ok
    end
  end

  def get_recipients(email) do
    Enum.concat(email["to"], email["cc"] || []) |> Enum.concat(email["bcc"] || [])
  end
end
