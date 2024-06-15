defmodule Phoenix00Web.EmailLive.Index do
  use Phoenix00Web, :live_view

  alias Phoenix00.Messages
  alias Phoenix00.Messages.Email

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :emails, [], page: 0, max_page: 1)}
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

  defp apply_action(socket, :index, params) do
    case Messages.list_emails_flop(params) do
      {:ok, {emails, meta}} ->
        socket
        |> assign(:page_title, "Listing Emails")
        |> assign(:form, Phoenix.Component.to_form(meta))
        |> assign(:meta, meta)
        |> stream(
          :emails,
          emails,
          reset: true
        )
    end
  end

  @impl true
  def handle_info({Phoenix00Web.EmailLive.FormComponent, {:saved, email}}, socket) do
    {:noreply, stream_insert(socket, :emails, email)}
  end

  def handle_event("update_filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/emails?#{params}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    email = Messages.get_email!(id)
    {:ok, _} = Messages.delete_email(email)

    {:noreply, stream_delete(socket, :emails, email)}
  end
end
