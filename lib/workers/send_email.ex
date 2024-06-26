defmodule Phoenix00.Workers.SendEmail do
  alias Phoenix00.Logs
  use Oban.Worker, queue: :mailer
  alias Phoenix00.Contacts
  alias Phoenix00.Mailer
  alias Phoenix00.Messages
  require Logger

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email_args}}) do
    recipients = get_destinations(email_args)

    with {:ok, email} <- Mailer.from_map(email_args),
         {:ok, metadata} <- Mailer.deliver(email),
         {:ok, email} <- create_email(email_args, metadata) do
      Enum.each(recipients, fn recipient -> create_message(email, recipient) end)
      :ok
    else
      {:error, e} ->
        Logs.create_log(%{
          status: 500,
          source: "queue:send",
          method: :post,
          request: email_args,
          response: %{error: e},
          token_id: email_args["token_id"],
          email_id: email_args["id"]
        })

        {:error, e}

      e ->
        Logs.create_log(%{
          status: 500,
          source: "queue:send",
          method: :post,
          request: email_args,
          response: %{error: e},
          token_id: email_args["token_id"],
          email_id: email_args["id"]
        })

        {:error, e}
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
    Messages.add_email_sender(email_args, %{sender_id: metadata.id})
  end
end
