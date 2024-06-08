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
    to = parse_destination(email["to"])
    cc = parse_destination(email["cc"])
    bcc = parse_destination(email["bcc"])

    Enum.concat(to, cc) |> Enum.concat(bcc) |> Enum.filter(&(!is_nil(&1)))
  end

  defp create_message(email, destination) do
    recipient =
      Contacts.create_or_find_recipient_by_destination(%{destination: destination})

    Messages.create_message(%{
      status: :sent,
      recipient: recipient.id,
      transmission: email.id
    })
  end

  defp parse_destination(destination) when is_list(destination) do
    destination
  end

  defp parse_destination(destination) when is_bitstring(destination) do
    [destination]
  end

  defp parse_destination(destination) when is_nil(destination) do
    []
  end

  defp create_email(email_args, metadata) do
    Messages.create_email(
      Map.merge(email_args, %{
        "sender_id" => metadata.id,
        "to" => parse_destination(email_args["to"])
      })
    )
  end
end
