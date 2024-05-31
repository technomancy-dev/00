defmodule Phoenix00.Messages.EmailRepo do
  # use Phoenix00, :repository
  import Ecto.Query, warn: false
  alias Phoenix00.Repo
  alias Phoenix00.Messages.Email

  def list_emails(lim \\ 10, off \\ 0, order \\ [desc: :updated_at]) do
    Email |> limit(^lim) |> offset(^off) |> order_by(^order) |> Repo.all()
  end

  def get_email!(id), do: Repo.get!(Email, id)

  def get_email_by_aws_id(aws_message_id, email) do
    Repo.get_by(Email, sender_id: aws_message_id, to: email)
  end

  def email_count() do
    Repo.aggregate(Email, :count, :id)
  end

  def create_email(attrs \\ %{}) do
    change_email(%Email{}, attrs)
    |> Repo.insert()
  end

  def update_email(%Email{} = email, attrs) do
    change_email(email, attrs)
    |> Repo.update()
  end

  def update_email(attrs) do
    change_email(%Email{}, attrs)
    |> Repo.update()
  end

  def delete_email(%Email{} = email) do
    Repo.delete(email)
  end

  def change_email(%Email{} = email, attrs \\ %{}) do
    Email.changeset(email, attrs)
  end
end
