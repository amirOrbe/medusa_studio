defmodule MedussaStudio.Repo.Migrations.CreateAppointments do
  use Ecto.Migration

  def change do
    create table(:appointments) do
      add :date, :date
      add :start_time, :time
      add :end_time, :time
      add :user_id, references(:users, on_delete: :nothing)
      add :service_id, references(:services, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:appointments, [:user_id])
    create index(:appointments, [:service_id])
  end
end
