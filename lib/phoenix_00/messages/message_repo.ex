defmodule Phoenix00.Messages.MessageRepo do
  import Ecto.Query, warn: false
  alias Phoenix00.Repo

  def update_status_by_sender_id_and_destinations(transmission_id, recipients, status) do
    Repo.update_all(get_messages_by_sender_id_and_recipients_query(transmission_id, recipients),
      set: [status: status]
    )
  end

  defp get_messages_by_sender_id_and_recipients_query(transmission_id, recipients) do
    from message in "messages",
      where: message.transmission == ^transmission_id and message.recipient in ^recipients,
      select: [:status]
  end
end
