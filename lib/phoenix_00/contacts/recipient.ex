defmodule Phoenix00.Contacts.Recipient do
  use Ecto.Schema
  import Ecto.Changeset

  schema "recipients" do
    field :destination, :string

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
