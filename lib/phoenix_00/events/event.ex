defmodule Phoenix00.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :status, :string
    belongs_to :message, Phoenix00.Contacts.Recipient, foreign_key: :message_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:status])
    |> cast_assoc(:recipient_id, with: &Phoenix00.Contacts.Recipient.changeset/2)
    |> validate_required([:status, :recipient_id])
    |> validate_required([:status])
  end
end
