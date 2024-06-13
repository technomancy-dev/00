defmodule Phoenix00.Messages.MessageRepo do
  import Ecto.Query, warn: false
  alias Phoenix00.Events
  alias Phoenix00.Messages.Message
  alias Phoenix00.Repo

  def update_status_by_sender_id_and_destinations(transmission_id, recipients, status) do
    Enum.each(recipients, fn recipient ->
      Events.create_event_for_message(
        ensure_message_exists(transmission_id, recipient),
        status
      )
    end)

    updates =
      Repo.all(get_messages_by_sender_id_and_recipients_query(transmission_id, recipients))
      |> Enum.map(
        &Fsmx.transition_changeset(&1, String.to_existing_atom(status), %{}, state_field: :status)
      )
      |> Enum.filter(fn changeset -> changeset.valid? end)

    Repo.transaction(fn -> Enum.map(updates, &Repo.update(&1)) end)
  end

  defp ensure_message_exists(transmission_id, recipient) do
    query =
      from message in Message,
        where: message.transmission == ^transmission_id and message.recipient_id == ^recipient

    if !Repo.one(query) do
      create_message(%{
        status: :sent,
        recipient_id: recipient,
        transmission: transmission_id
      })
    end

    Repo.one(query)
  end

  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  defp get_messages_by_sender_id_and_recipients_query(transmission_id, recipients) do
    from message in Message,
      where: message.transmission == ^transmission_id and message.recipient_id in ^recipients
  end
end
