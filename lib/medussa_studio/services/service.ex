defmodule MedussaStudio.Services.Service do
  alias MedussaStudio.AppointmentsServices.AppointmentService
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :name, :string
    field :price, :decimal

    many_to_many :appointment_services, MedussaStudio.Appointments.Appointment,
      join_through: AppointmentService,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:name, :price])
    |> validate_required([:name, :price])
  end
end
