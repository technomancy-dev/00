defmodule Phoenix00.Repo.Migrations.CreateRecipients do
  use Ecto.Migration

  def change do
    create table(:recipients) do
      add :destination, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:recipients, :destination)
  end
end
