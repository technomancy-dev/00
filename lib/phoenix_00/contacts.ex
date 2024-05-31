defmodule Phoenix00.Contacts do
  @moduledoc """
  The Contacts context.
  """

  import Ecto.Query, warn: false
  alias Phoenix00.Repo

  alias Phoenix00.Contacts.Recipient

  @doc """
  Returns the list of recipients.

  ## Examples

      iex> list_recipients()
      [%Recipient{}, ...]

  """
  def list_recipients do
    Repo.all(Recipient)
  end

  @doc """
  Gets a single recipient.

  Raises `Ecto.NoResultsError` if the Recipient does not exist.

  ## Examples

      iex> get_recipient!(123)
      %Recipient{}

      iex> get_recipient!(456)
      ** (Ecto.NoResultsError)

  """
  def get_recipient!(id), do: Repo.get!(Recipient, id)

  @doc """
  Creates a recipient.

  ## Examples

      iex> create_recipient(%{field: value})
      {:ok, %Recipient{}}

      iex> create_recipient(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_recipient(attrs \\ %{}) do
    %Recipient{}
    |> Recipient.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a recipient.

  ## Examples

      iex> update_recipient(recipient, %{field: new_value})
      {:ok, %Recipient{}}

      iex> update_recipient(recipient, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_recipient(%Recipient{} = recipient, attrs) do
    recipient
    |> Recipient.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a recipient.

  ## Examples

      iex> delete_recipient(recipient)
      {:ok, %Recipient{}}

      iex> delete_recipient(recipient)
      {:error, %Ecto.Changeset{}}

  """
  def delete_recipient(%Recipient{} = recipient) do
    Repo.delete(recipient)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking recipient changes.

  ## Examples

      iex> change_recipient(recipient)
      %Ecto.Changeset{data: %Recipient{}}

  """
  def change_recipient(%Recipient{} = recipient, attrs \\ %{}) do
    Recipient.changeset(recipient, attrs)
  end
end
