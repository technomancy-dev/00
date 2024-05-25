defmodule Phoenix00.Messages.Email do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emails" do
    field :status, Ecto.Enum, values: [:pending, :sent, :delivered, :bounced, :complained]
    field :to, :string
    field :from, :string
    field :aws_message_id, :string
    field :email_id, :string
    field :sent_by, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [:aws_message_id, :to, :from, :status, :email_id])
    |> validate_required([:to, :from, :status])
    |> unique_constraint(:email_id)
  end
end
