defmodule MedussaStudio.Services.Service do
  use Ecto.Schema
  import Ecto.Changeset

  schema "services" do
    field :name, :string
    field :price, :decimal

    many_to_many :appointments, MedussaStudio.Appointments.Appointment,
      join_through: "appointments_services"

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(service, attrs) do
    service
    |> cast(attrs, [:name, :price])
    |> validate_required([:name, :price])
  end
end
