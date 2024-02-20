defmodule MedussaStudioWeb.AppointmentLive.Show do
  use MedussaStudioWeb, :live_view

  alias MedussaStudio.Appointments

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:appointment, Appointments.get_appointment!(id))}
  end

  defp page_title(:show), do: "Ver Cita"
  defp page_title(:edit), do: "Editar Cita"
end
