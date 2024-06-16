defmodule Phoenix00.Messages.Message do
  use Phoenix00.UUIDSchema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:status, :destination, :from, :date_range, :subject],
    sortable: [:status, :inserted_at],
    max_limit: 100,
    default_limit: 12,
    default_order: %{
      order_by: [:inserted_at],
      order_directions: [:desc, :asc]
    },
    adapter_opts: [
      custom_fields: [
        date_range: [
          filter: {CustomFilters, :date_range, [source: :inserted_at, timezone: "-7 days"]},
          ecto_type: :string,
          operators: [:>=]
        ]
      ],
      join_fields: [
        destination: [
          binding: :recipient,
          field: :destination,
          ecto_type: :string
        ],
        from: [
          binding: :email,
          field: :from,
          ecto_type: :string
        ],
        subject: [
          binding: :email,
          field: :subject,
          ecto_type: :string
        ]
      ]
    ]
  }

  schema "messages" do
    field :status, Ecto.Enum, values: [:pending, :sent, :delivered, :bounced, :complained]
    has_many :events, Phoenix00.Events.Event

    belongs_to :email, Phoenix00.Messages.Email, foreign_key: :transmission
    belongs_to :recipient, Phoenix00.Contacts.Recipient, foreign_key: :recipient_id

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
    |> cast(attrs, [:status, :recipient_id, :transmission])
    |> validate_required([:status, :recipient_id, :transmission])
    |> unique_constraint([:recipient_id, :transmission])
  end
end
