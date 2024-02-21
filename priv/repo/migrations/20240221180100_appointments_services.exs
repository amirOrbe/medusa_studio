defmodule MedussaStudio.Repo.Migrations.AppointmentsServices do
  use Ecto.Migration

  def change do
    create table(:appointments_services, primary_key: false) do
      add :appointment_id, references(:appointments, on_delete: :delete_all)
      add :service_id, references(:services, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:appointments_services, [:appointment_id, :service_id])
  end
end
