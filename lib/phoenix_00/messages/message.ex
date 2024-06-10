defmodule Phoenix00.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :status, Ecto.Enum, values: [:pending, :sent, :delivered, :bounced, :complained]
    field :recipient, :id
    field :transmission, :id

    timestamps(type: :utc_datetime)
  end

  use Fsmx.Struct,
    state_field: :status,
    transitions: %{
      :pending => :*,
      :sent => [:complained, :bounced, :delivered],
      :* => [:bounced, :complained]
    }

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:status, :recipient, :transmission])
    |> validate_required([:status, :recipient, :transmission])
  end
end
