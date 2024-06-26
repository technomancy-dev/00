defmodule Phoenix00.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :status, :string
      add :recipient_id, references(:recipients, on_delete: :nothing)
      add :transmission, references(:emails, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:messages, [:recipient_id])
    create index(:messages, [:transmission])
    create unique_index(:messages, [:recipient_id, :transmission])
  end
end
