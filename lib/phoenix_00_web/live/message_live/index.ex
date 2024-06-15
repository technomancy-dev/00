defmodule Phoenix00Web.MessageLive.Index do
  use Phoenix00Web, :live_view

  alias Phoenix00.Messages
  alias Phoenix00.Messages.Message

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :messages, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Message")
    |> assign(:message, Messages.get_message!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Message")
    |> assign(:message, %Message{})
  end

  defp apply_action(socket, :index, params) do
    case Messages.list_messages_flop(params) do
      {:ok, {messages, meta}} ->
        socket
        |> assign(:page_title, "New Message")
        |> stream(
          :messages,
          messages,
          reset: true
        )
        |> assign(:form, Phoenix.Component.to_form(meta))
        |> assign(:meta, meta)
        |> assign(:message, nil)

      {:error, meta} ->
        # This will reset invalid parameters. Alternatively, you can assign
        # only the meta and render the errors, or you can ignore the error
        # case entirely.
        push_navigate(socket, to: ~p"/messages")
    end
  end

  @impl true
  def handle_info({Phoenix00Web.MessageLive.FormComponent, {:saved, message}}, socket) do
    {:noreply, stream_insert(socket, :messages, message)}
  end

  def handle_event("update_filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/messages?#{params}")}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    message = Messages.get_message!(id)
    {:ok, _} = Messages.delete_message(message)

    {:noreply, stream_delete(socket, :messages, message)}
  end
end
