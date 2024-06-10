defmodule Phoenix00.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :status, :string
      add :recipient, references(:recipients, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:events, [:recipient])
  end
end
