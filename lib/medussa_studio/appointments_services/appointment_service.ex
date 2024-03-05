defmodule MedussaStudio.AppointmentsServices.AppointmentService do
  use Ecto.Schema

  @primary_key false
  schema "appointments_services" do
    belongs_to :service, MedussaStudio.Services.Service
    belongs_to :appointment, MedussaStudio.Appointments.Appointment

    timestamps()
  end
end
