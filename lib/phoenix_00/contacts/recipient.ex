defmodule Phoenix00.Contacts.Recipient do
  use Phoenix00.UUIDSchema
  import Ecto.Changeset

  schema "recipients" do
    field :destination, :string
    has_many :messages, Phoenix00.Contacts.Recipient, foreign_key: :recipient_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(recipient, attrs) do
    recipient
    |> cast(attrs, [:destination])
    |> validate_required([:destination])
    |> unique_constraint(:destination)
  end
end
