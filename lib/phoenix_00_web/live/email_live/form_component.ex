defmodule Phoenix00Web.EmailLive.FormComponent do
  require Logger
  use Phoenix00Web, :live_component

  alias Phoenix00.Messages

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage email records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="email-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:aws_message_id]} type="text" label="Aws message" />
        <.input field={@form[:to]} type="text" label="To" />
        <.input field={@form[:from]} type="text" label="From" />
        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          prompt="Choose a value"
          options={Ecto.Enum.values(Phoenix00.Messages.Email, :status)}
        />
        <.input field={@form[:email_id]} type="text" label="Email" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Email</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{email: email} = assigns, socket) do
    changeset = Messages.change_email(email)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"email" => email_params}, socket) do
    changeset =
      socket.assigns.email
      |> Messages.change_email(email_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"email" => email_params}, socket) do
    save_email(socket, socket.assigns.action, email_params)
  end

  defp save_email(socket, :edit, email_params) do
    case Messages.update_email(socket.assigns.email, email_params) do
      {:ok, email} ->
        notify_parent({:saved, email})

        {:noreply,
         socket
         |> put_flash(:info, "Email updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_email(_socket, :new, _email_params) do
    Logger.warning("Create Email UI is not implemented.")
    # case Messages.create_email(email_params) do
    #   {:ok, email} ->
    #     notify_parent({:saved, email})

    #     {:noreply,
    #      socket
    #      |> put_flash(:info, "Email created successfully")
    #      |> push_patch(to: socket.assigns.patch)}

    #   {:error, %Ecto.Changeset{} = changeset} ->
    #     {:noreply, assign_form(socket, changeset)}
    # end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
