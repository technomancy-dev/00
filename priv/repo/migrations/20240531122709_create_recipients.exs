defmodule Phoenix00.Repo.Migrations.CreateRecipients do
  use Ecto.Migration

  def change do
    create table(:recipients) do
      add :destination, :string

      timestamps(type: :utc_datetime)
    end
  end
end
