defmodule Phoenix00.Messages do
  require Ecto.Query
  alias Phoenix00.Messages.Email
  alias Phoenix00.Contacts.Recipient
  alias Phoenix00.Messages.Message
  alias Phoenix00.Messages.EmailRepo
  alias Phoenix00.Messages.Services
  alias Phoenix00.Repo

  def send_email(email_req) do
    Services.SendEmail.call(email_req)
  end

  def recieve_sns(sns) do
    Services.RecieveSns.call(sns)
  end

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
end
