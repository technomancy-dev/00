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
           Messages.create_email(
             Map.merge(email_args, %{
               "sender_id" => metadata.id,
               "to" => List.flatten([email_args["to"]])
             })
           ) do
      Enum.each(recipients, fn recipient ->
        recipient =
          Contacts.create_or_find_recipient_by_destination(%{destination: recipient})

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
    to = List.flatten([email["to"]])
    cc = List.flatten([email["cc"]])
    bcc = List.flatten([email["bcc"]])

    Enum.concat(to, cc) |> Enum.concat(bcc) |> Enum.filter(&(!is_nil(&1)))
  end
end
