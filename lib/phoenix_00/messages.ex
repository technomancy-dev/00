defmodule Phoenix00.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false
  alias Phoenix00.Repo

  alias Phoenix00.Messages.Email
  alias Phoenix00.UserEmail
  alias Phoenix00.Mailer
  require Logger

  @doc """
  Returns the list of emails.

  ## Examples

      iex> list_emails()
      [%Email{}, ...]

  """
  def list_emails do
    Repo.all(Email)
  end

  @doc """
  Gets a single email.

  Raises `Ecto.NoResultsError` if the Email does not exist.

  ## Examples

      iex> get_email!(123)
      %Email{}

      iex> get_email!(456)
      ** (Ecto.NoResultsError)

  """
  def get_email!(id), do: Repo.get!(Email, id)

  def get_email_by_aws_id(aws_message_id) do
    Repo.get_by(Email, aws_message_id: aws_message_id)
  end

  @doc """
  Creates a email.

  ## Examples

      iex> create_email(%{field: value})
      {:ok, %Email{}}

      iex> create_email(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_email(attrs \\ %{}) do
    %Email{}
    |> Email.changeset(attrs)
    |> Repo.insert()
  end

  def send_email(
        %{"from" => from, "to" => to, "subject" => subject, "body" => body, "text" => text} =
          email_req
      ) do
    email = UserEmail.welcome(to, from, subject, body, text)

    with {:ok, mail} <- Mailer.deliver(email),
         {:ok} <-
           Repo.insert(merge_aws_with_email(email_req, mail)) do
      :ok
    else
      _ -> :error
    end
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
         {:ok, _response} <- handle_notification_message(jason) do
      {:ok, %{success: true}}
    end
  end

  def handle_notification_message(%{"eventType" => "Send"} = message) do
    IO.inspect("IT'S SEND")
    IO.inspect(message)
    {:ok, %{}}
  end

  def handle_notification_message(message) do
    with {:ok, _} <-
           get_email_by_aws_id(message["mail"]["messageId"])
           |> update_email(%{
             status: get_status_from_event_type(message["eventType"])
           }) do
      {:ok, %{success: true}}
    end
  end

  def merge_aws_with_email(aws, email) do
    %Email{}
    |> Email.changeset(
      Map.merge(aws, %{
        "aws_message_id" => email[:id],
        "status" => "pending",
        "email_id" => email[:request_id]
      })
    )
  end

  @doc """
  Updates a email.

  ## Examples

      iex> update_email(email, %{field: new_value})
      {:ok, %Email{}}

      iex> update_email(email, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_email(%Email{} = email, attrs) do
    email
    |> Email.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a email.

  ## Examples

      iex> delete_email(email)
      {:ok, %Email{}}

      iex> delete_email(email)
      {:error, %Ecto.Changeset{}}

  """
  def delete_email(%Email{} = email) do
    Repo.delete(email)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking email changes.

  ## Examples

      iex> change_email(email)
      %Ecto.Changeset{data: %Email{}}

  """
  def change_email(%Email{} = email, attrs \\ %{}) do
    Email.changeset(email, attrs)
  end

  defp get_status_from_event_type(event_type) do
    case event_type do
      "Bounce" -> "bounced"
      "Complain" -> "complained"
      "Send" -> "sent"
      "Pending" -> "pending"
    end
  end
end
