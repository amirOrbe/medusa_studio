defmodule MedussaStudio.Appointments.Appointment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "appointments" do
    field :date, :date
    field :start_time, :time
    field :end_time, :time
    field :user_id, :id
    field :service_id, :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(appointment, attrs) do
    appointment
    |> cast(attrs, [:date, :start_time, :end_time])
    |> validate_required([:date, :start_time, :end_time])
  end
end
