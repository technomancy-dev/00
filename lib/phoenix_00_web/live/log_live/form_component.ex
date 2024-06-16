defmodule Phoenix00Web.LogLive.FormComponent do
  use Phoenix00Web, :live_component

  alias Phoenix00.Logs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage log records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="log-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:status]} type="number" label="Status" />
        <.input field={@form[:endpoint]} type="text" label="Endpoint" />
        <.input
          field={@form[:method]}
          type="select"
          label="Method"
          prompt="Choose a value"
          options={Ecto.Enum.values(Phoenix00.Logs.Log, :method)}
        />
        <.input field={@form[:ke_name]} type="text" label="Ke name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Log</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{log: log} = assigns, socket) do
    changeset = Logs.change_log(log)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"log" => log_params}, socket) do
    changeset =
      socket.assigns.log
      |> Logs.change_log(log_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"log" => log_params}, socket) do
    save_log(socket, socket.assigns.action, log_params)
  end

  defp save_log(socket, :edit, log_params) do
    case Logs.update_log(socket.assigns.log, log_params) do
      {:ok, log} ->
        notify_parent({:saved, log})

        {:noreply,
         socket
         |> put_flash(:info, "Log updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_log(socket, :new, log_params) do
    case Logs.create_log(log_params) do
      {:ok, log} ->
        notify_parent({:saved, log})

        {:noreply,
         socket
         |> put_flash(:info, "Log created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
