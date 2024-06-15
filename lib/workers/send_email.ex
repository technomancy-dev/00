defmodule Phoenix00.Workers.SendEmail do
  use Oban.Worker, queue: :mailer
  alias Phoenix00.Contacts
  alias Phoenix00.Mailer
  alias Phoenix00.Messages
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email_args}}) do
    recipients = get_destinations(email_args)

    with email <- Mailer.from_map(email_args),
         {:ok, metadata} <- Mailer.deliver(email),
         {:ok, email} <- create_email(email_args, metadata) do
      Enum.each(recipients, fn recipient -> create_message(email, recipient) end)
      :ok
    else
      _ -> :error
    end
  end

  defp get_destinations(email) do
    to = List.wrap(email["to"])
    cc = List.wrap(email["cc"])
    bcc = List.wrap(email["bcc"])

    Enum.concat(to, cc) |> Enum.concat(bcc) |> Enum.filter(&(!is_nil(&1)))
  end

  defp create_message(email, destination) do
    recipient =
      Contacts.create_or_find_recipient_by_destination(%{destination: destination})

    Messages.create_message(%{
      status: :pending,
      recipient_id: recipient.id,
      transmission: email.id
    })
  end

  defp create_email(email_args, metadata) do
    Messages.create_email(
      Map.merge(email_args, %{
        "sender_id" => metadata.id,
        "to" => List.wrap(email_args["to"]),
        "cc" => List.wrap(email_args["cc"]),
        "bcc" => List.wrap(email_args["bcc"]),
        "body" => email_args["html_body"]
      })
    )
  end
end
