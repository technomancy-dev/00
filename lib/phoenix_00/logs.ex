defmodule Phoenix00.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false

  alias Phoenix00.Accounts.UserToken
  alias Phoenix00.Repo

  alias Phoenix00.Logs.Log

  @doc """
  Returns the list of logs.

  ## Examples

      iex> list_logs()
      [%Log{}, ...]

  """
  def list_logs do
    Repo.all(
      Log
      |> Ecto.Query.join(:inner, [log], token in UserToken, on: log.token_id == token.id)
      |> Ecto.Query.select([log, token], %{
        log
        | token_id: %{name: token.name, id: token.id}
      })
    )
  end

  def list_logs_flop(params) do
    Log
    |> Ecto.Query.join(:inner, [log], token in UserToken, on: log.token_id == token.id)
    |> Flop.validate_and_run(params, for: Log)
  end

  @doc """
  Gets a single log.

  Raises `Ecto.NoResultsError` if the Log does not exist.

  ## Examples

      iex> get_log!(123)
      %Log{}

      iex> get_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_log!(id),
    do:
      Repo.get!(
        Log
        |> Ecto.Query.join(:inner, [log], token in UserToken, on: log.token_id == token.id)
        |> preload(:email)
        |> Ecto.Query.select([log, token, email], %{
          log
          | token_id: %{name: token.name, id: token.id}
        }),
        id
      )

  @doc """
  Creates a log.

  ## Examples

      iex> create_log(%{field: value})
      {:ok, %Log{}}

      iex> create_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_log(attrs \\ %{}) do
    %Log{}
    |> Log.changeset(attrs)
    |> Repo.insert()
  end

  def create_log_for_key(key, attrs) do
    Ecto.build_assoc(key, :logs, attrs)
    |> Repo.insert()

    # %Log{}
    # |> Log.changeset(attrs)
    # |> Repo.insert()
  end

  @doc """
  Updates a log.

  ## Examples

      iex> update_log(log, %{field: new_value})
      {:ok, %Log{}}

      iex> update_log(log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_log(%Log{} = log, attrs) do
    log
    |> Log.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a log.

  ## Examples

      iex> delete_log(log)
      {:ok, %Log{}}

      iex> delete_log(log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_log(%Log{} = log) do
    Repo.delete(log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking log changes.

  ## Examples

      iex> change_log(log)
      %Ecto.Changeset{data: %Log{}}

  """
  def change_log(%Log{} = log, attrs \\ %{}) do
    Log.changeset(log, attrs)
  end
end
