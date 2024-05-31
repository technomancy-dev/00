defmodule Phoenix00.Repo.Migrations.UpdateEmailsToIncludeSenderId do
  use Ecto.Migration

  def change do
    alter table(:emails) do
      add :sender_id, :string
      add :batch, :string
      add :body, :string
      remove :aws_message_id, :string

      create unique_index(:emails, [:to, :batch_id])
    end
  end
end
