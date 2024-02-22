defmodule MedussaStudioWeb.AppointmentLive.FormComponent do
  use MedussaStudioWeb, :live_component

  alias MedussaStudio.Appointments
  alias MedussaStudio.Services
  alias MedussaStudio.Repo

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
          field={@form[:service_ids]}
          type="select"
          label="Servicios"
          multiple={true}
          options={list_services_with_id()}
          class="scroll-smooth md:scroll-auto"
        />
        <p class="mt-2 text-xs text-neutral-500">
          Mantenga presionada la tecla <kbd>Ctrl</kbd>
          (o <kbd>Command</kbd>
          en Mac) para seleccionar o anular varios grupos.
        </p>
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
    %{"service_ids" => service_ids} = appointment_params
    service_ids = Enum.map(service_ids, &String.to_integer/1)
    updated_params = Map.put(appointment_params, "service_ids", service_ids)
    IO.inspect(updated_params, label: "updated_params params--->")

    case Appointments.create_appointment(add_user_id_to_appointment(socket, updated_params)) do
      {:ok, appointment} ->
        updated_appointment =
          appointment
          |> Ecto.Changeset.change()
          |> Map.put(:services, Enum.map(service_ids, &Services.get_service!/1))
          |> Repo.update()

        case updated_appointment do
          {:ok, appointment} ->
            notify_parent({:saved, appointment})

            {:noreply,
             socket
             |> put_flash(:info, "Appointment created successfully")
             |> push_patch(to: socket.assigns.patch)}

          {:error, %Ecto.Changeset{} = changeset} ->
            {:noreply, assign_form(socket, changeset)}
        end

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

  defp list_services_with_id(),
    do: Enum.map(Services.list_services(), fn %{id: id, name: name} -> {name, id} end)
end
