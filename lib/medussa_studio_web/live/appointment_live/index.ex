defmodule MedussaStudioWeb.AppointmentLive.Index do
  use MedussaStudioWeb, :live_view

  alias MedussaStudio.Appointments
  alias MedussaStudio.Appointments.Appointment

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :appointments, Appointments.list_appointments())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Editar cita")
    |> assign(:user_id, get_current_user_id(socket))
    |> assign(:appointment, Appointments.get_appointment!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Nueva cita")
    |> assign(:appointment, %Appointment{user_id: get_current_user_id(socket)})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Lista de citas")
    |> assign(:appointment, nil)
    |> assign(:user_id, get_current_user_id(socket))
  end

  @impl true
  def handle_info({MedussaStudioWeb.AppointmentLive.FormComponent, {:saved, appointment}}, socket) do
    {:noreply, stream_insert(socket, :appointments, appointment)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    appointment = Appointments.get_appointment!(id)
    {:ok, _} = Appointments.delete_appointment(appointment)

    {:noreply, stream_delete(socket, :appointments, appointment)}
  end

  defp get_current_user_id(%{assigns: %{current_user: %{id: id}}}), do: id
end
