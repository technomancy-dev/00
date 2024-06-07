defmodule Phoenix00.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    create table(:emails) do
      add :sender_id, :string
      add :to, {:array, :string}
      add :from, :string
      add :status, :string
      add :email_id, :string
      add :batch, :string
      add :body, :string
      add :sent_by, references(:users, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:emails, [:email_id])
    create unique_index(:emails, [:sender_id])
    create unique_index(:emails, [:to, :sender_id])
    create index(:emails, [:sent_by])
  end
end
