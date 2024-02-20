defmodule MedussaStudio.AppointmentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MedussaStudio.Appointments` context.
  """

  @doc """
  Generate a appointment.
  """
  def appointment_fixture(attrs \\ %{}) do
    {:ok, appointment} =
      attrs
      |> Enum.into(%{
        date: ~D[2024-02-19],
        end_time: ~T[14:00:00],
        start_time: ~T[14:00:00]
      })
      |> MedussaStudio.Appointments.create_appointment()

    appointment
  end
end
