defmodule Phoenix00.Events.Event do
  use Ecto.Schema
  import Ecto.Changeset

  schema "events" do
    field :status, :string
    field :recipient, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:status])
    |> validate_required([:status])
  end
end
