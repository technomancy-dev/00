defmodule Phoenix00.Messages do
  require Ecto.Query
  alias Phoenix00.Messages.Email
  alias Phoenix00.Contacts.Recipient
  alias Phoenix00.Messages.Message
  alias Phoenix00.Messages.EmailRepo
  alias Phoenix00.Messages.Services
  alias Phoenix00.Messages.MessageRepo
  alias Phoenix00.Contacts
  alias Phoenix00.Repo

  def send_email(email_req) do
    Services.SendEmail.call(email_req)
  end

  # def recieve_sns(sns) do
  #   Services.RecieveSns.call(sns)
  # end

  defdelegate list_emails(limit, offset), to: EmailRepo
  defdelegate get_email!(id), to: EmailRepo
  defdelegate email_count(), to: EmailRepo
  defdelegate change_email(attrs), to: EmailRepo
  defdelegate change_email(email, attrs), to: EmailRepo
  defdelegate create_email(attrs), to: EmailRepo
  defdelegate update_email(email), to: EmailRepo
  defdelegate update_email(email, attr), to: EmailRepo
  defdelegate delete_email(email), to: EmailRepo

  @doc """
  Returns the list of messages.

  ## Examples

      iex> list_messages()
      [%Message{}, ...]

  """
  def list_messages do
    Repo.all(
      Message
      |> Ecto.Query.join(:inner, [m], r in Recipient, on: m.recipient == r.id)
      |> Ecto.Query.join(:inner, [m], e in Email, on: m.transmission == e.id)
      |> Ecto.Query.select([m, r, email], %{
        m
        | recipient: r.destination,
          transmission: email
      })
    )
  end

  @doc """
  Gets a single message.

  Raises `Ecto.NoResultsError` if the Message does not exist.

  ## Examples

      iex> get_message!(123)
      %Message{}

      iex> get_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_message!(id), do: Repo.get!(Message, id)

  @doc """
  Creates a message.

  ## Examples

      iex> create_message(%{field: value})
      {:ok, %Message{}}

      iex> create_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message(attrs \\ %{}) do
    %Message{}
    |> Message.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message.

  ## Examples

      iex> update_message(message, %{field: new_value})
      {:ok, %Message{}}

      iex> update_message(message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message(%Message{} = message, attrs) do
    message
    |> Message.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message.

  ## Examples

      iex> delete_message(message)
      {:ok, %Message{}}

      iex> delete_message(message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message(%Message{} = message) do
    Repo.delete(message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message changes.

  ## Examples

      iex> change_message(message)
      %Ecto.Changeset{data: %Message{}}

  """
  def change_message(%Message{} = message, attrs \\ %{}) do
    Message.changeset(message, attrs)
  end

  def recieve_sns(sns) do
    with :ok <- ExAws.SNS.verify_message(sns) do
      handle_sns(sns)
    end
  end

  def handle_sns(%{
        "Type" => "Notification",
        "Message" => message
      }) do
    with {:ok, jason} <- Jason.decode(message),
         email <- EmailRepo.find_or_create_email_record_by_ses_message(jason),
         recipients <- Enum.map(get_recipients(jason), fn recipient -> recipient.id end) do
      update_messages(email.id, recipients, get_status_from_event_type(jason["eventType"]))
    end
  end

  # def handle_notification_message(%{"eventType" => "Send"} = message) do
  #   # Send events are special, the user may not use the send API and use AWS SES directly
  #   # within their app. Because of that we need to create the email record if it doesn't exist.
  #   # find_or_create_email_record(message)
  #   with {:ok, jason} <- Jason.decode(message),
  #        email <- EmailRepo.get_email_by_aws_id(jason["mail"]["messageId"]),
  #        recipients <- Enum.map(get_recipients(jason), fn recipient -> recipient.id end) do
  #     update_messages(email.id, recipients, get_status_from_event_type(jason["eventType"]))
  #   end
  # end

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
    Contacts.create_or_find_recipient_by_destination(
      Enum.map(get_recipients_by_message(sns), fn email_map ->
        case is_map(email_map) do
          true -> %{destination: email_map["emailAddress"]}
          false -> %{destination: email_map}
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
