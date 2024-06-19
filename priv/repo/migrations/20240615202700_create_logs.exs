defmodule Phoenix00.Repo.Migrations.CreateLogs do
  use Ecto.Migration

  def change do
    create table(:logs) do
      add :status, :integer
      add :source, :string
      add :method, :string
      add :response, :map, default: "{}"
      add :request, :map, default: "{}"
      add :token_id, :id
      add :email_id, references(:emails, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:logs, [:email_id])
  end
end
