defmodule MedussaStudioWeb.AppointmentLive.Show do
  use MedussaStudioWeb, :live_view

  alias MedussaStudio.Appointments
  alias MedussaStudio.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token}, socket) do
    current_user = Accounts.get_user_by_session_token(user_token)

    {:ok, assign(socket, current_user: current_user)}
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
