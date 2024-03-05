defmodule MedussaStudio.Appointments.Appointment do
  alias MedussaStudio.AppointmentsServices.AppointmentService
  alias MedussaStudio.Accounts
  use Ecto.Schema
  import Ecto.Changeset

  schema "appointments" do
    field :date, :date
    field :start_time, :time
    field :end_time, :time
    belongs_to :user, Accounts.User
    many_to_many :appointment_services, MedussaStudio.Services.Service,
      join_through: AppointmentService,
      on_replace: :delete

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(appointment, attrs) do
    appointment
    |> cast(attrs, [:date, :start_time, :end_time, :user_id])
    |> validate_required([:date, :start_time, :end_time])
  end
end
