defmodule Phoenix00Web.EmailLive.Index do
  use Phoenix00Web, :live_view

  alias Phoenix00.Messages
  alias Phoenix00.Messages.Email

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :emails, Messages.list_emails())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Email")
    |> assign(:email, Messages.get_email!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Email")
    |> assign(:email, %Email{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Emails")
    |> assign(:email, nil)
  end

  @impl true
  def handle_info({Phoenix00Web.EmailLive.FormComponent, {:saved, email}}, socket) do
    {:noreply, stream_insert(socket, :emails, email)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    email = Messages.get_email!(id)
    {:ok, _} = Messages.delete_email(email)

    {:noreply, stream_delete(socket, :emails, email)}
  end
end
