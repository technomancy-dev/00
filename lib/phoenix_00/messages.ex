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

    with {:ok, mail} <- Mailer.deliver(email) do
      IO.inspect("YUUUUP")
      IO.inspect(mail)

      record =
        %Email{}
        |> Email.changeset(
          Map.merge(email_req, %{
            "aws_message_id" => mail[:id],
            "status" => "pending",
            "email_id" => mail[:request_id]
          })
        )

      with {:ok, response} <- Repo.insert(record) do
        IO.inspect(response)
      else
        {:error, reason} -> IO.inspect(reason)
      end
    else
      {:error, reason} -> {:error, reason}
    end
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
end
