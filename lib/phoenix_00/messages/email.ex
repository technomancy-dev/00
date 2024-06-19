defmodule Phoenix00.Messages.Email do
  use Phoenix00.UUIDSchema
  import Ecto.Changeset

  @derive {
    Flop.Schema,
    filterable: [:status, :from, :date_range, :subject],
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
        status: [
          binding: :messages,
          field: :status,
          ecto_type: :string
        ]
      ]
    ]
  }

  schema "emails" do
    field :status, Ecto.Enum, values: [:pending, :sent, :delivered, :bounced, :complained]
    field :to, {:array, :string}
    field :cc, {:array, :string}
    field :bcc, {:array, :string}
    field :reply_to, {:array, :string}
    field :body, :string
    field :text, :string
    field :subject, :string
    field :from, :string
    field :email_id, :string
    field :sender_id, :string
    field :sent_by, :id

    # has_many :recipients, Phoenix00.Contacts.Recipient
    has_many :messages, Phoenix00.Messages.Message, foreign_key: :transmission
    has_many :logs, Phoenix00.Logs.Log
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [:to, :from, :sender_id, :body, :cc, :bcc, :reply_to, :subject])
    |> validate_required([:to, :from, :sender_id, :body])
    |> unique_constraint(:email_id)
  end

  def receive_changeset(email, attrs) do
    email
    |> cast(attrs, [:to, :from, :body, :text, :cc, :bcc, :reply_to, :subject])
    |> validate_required([:to, :from, :body, :text])
  end

  def send_changeset(email, attrs) do
    email
    |> cast(attrs, [:sender_id])
    |> validate_required([:sender_id])
    |> unique_constraint(:sender_id)
  end
end
