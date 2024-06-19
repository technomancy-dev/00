defmodule Phoenix00.Logs.Log do
  use Phoenix00.UUIDSchema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:status, :source, :method, :date_range, :token_id],
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
        # token_id: [
        #   binding: :token_id,
        #   field: :id,
        #   ecto_type: :id
        # ]
      ]
    ]
  }

  schema "logs" do
    field :status, :integer
    field :request, :map
    field :response, :map
    field :source, :string
    field :method, Ecto.Enum, values: [:get, :head, :post, :put, :delete, :options, :patch]
    field :token_id, :string

    belongs_to :email, Phoenix00.Messages.Email
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:status, :source, :method, :response, :request, :token_id, :email_id])
    |> validate_required([:status, :source, :method, :token_id])
  end
end
