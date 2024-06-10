defmodule Phoenix00.Messages.Email do
  use Ecto.Schema
  import Ecto.Changeset

  schema "emails" do
    field :status, Ecto.Enum, values: [:pending, :sent, :delivered, :bounced, :complained]
    field :to, {:array, :string}
    field :cc, {:array, :string}
    field :bcc, {:array, :string}
    field :reply_to, {:array, :string}
    field :body, :string
    field :from, :string
    field :email_id, :string
    field :sender_id, :string
    field :sent_by, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [:to, :from, :sender_id, :body, :cc, :bcc, :reply_to])
    |> validate_required([:to, :from, :sender_id, :body])
    |> unique_constraint(:email_id)
  end
end
