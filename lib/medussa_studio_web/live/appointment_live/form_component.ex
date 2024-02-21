defmodule MedussaStudioWeb.AppointmentLive.FormComponent do
  use MedussaStudioWeb, :live_component

  alias MedussaStudio.Appointments

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>
          Utilice este formulario para administrar registros de citas en su base de datos.
        </:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="appointment-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input
          field={@form[:date]}
          type="date"
          label="Fecha"
          class="border-red-300 rounded-md shadow-sm"
        />

        <.input field={@form[:start_time]} type="time" label="Hora de Inicio" />
        <.input field={@form[:end_time]} type="time" label="Hora de Fin" />
        <.input
          field={@form[:service]}
          type="select"
          label="Servicio"
          options={["option 1", "option 2"]}
          class="scroll-smooth md:scroll-auto"
        />
        <:actions>
          <.button phx-disable-with="Guardando...">Guardar Cita</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{appointment: appointment} = assigns, socket) do
    changeset = Appointments.change_appointment(appointment)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"appointment" => appointment_params}, socket) do
    changeset =
      socket.assigns.appointment
      |> Appointments.change_appointment(appointment_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"appointment" => appointment_params}, socket) do
    save_appointment(socket, socket.assigns.action, appointment_params)
  end

  defp save_appointment(socket, :edit, appointment_params) do
    case Appointments.update_appointment(
           socket.assigns.appointment,
           add_user_id_to_appointment(socket, appointment_params)
         ) do
      {:ok, appointment} ->
        notify_parent({:saved, appointment})

        {:noreply,
         socket
         |> put_flash(:info, "Appointment updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_appointment(socket, :new, appointment_params) do
    case Appointments.create_appointment(add_user_id_to_appointment(socket, appointment_params)) do
      {:ok, appointment} ->
        notify_parent({:saved, appointment})

        {:noreply,
         socket
         |> put_flash(:info, "Appointment created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})

  defp add_user_id_to_appointment(
         %{assigns: %{appointment: %{user_id: user_id}}},
         appointment_params
       ),
       do: Map.put(appointment_params, "user_id", user_id)
end
