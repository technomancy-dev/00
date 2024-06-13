defmodule Phoenix00Web.MessageLive.Show do
  use Phoenix00Web, :live_view

  alias Phoenix00.Messages

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:message, Messages.get_message!(id))}
  end

  def sort_events(events) do
    order = ["pending", "sent", "delivered", "bounced", "complained"]
    order_idx = order |> Enum.zip(1..5) |> Map.new()
    Enum.sort_by(events, &order_idx[&1.status])
  end

  defp page_title(:show), do: "Show Message"
  defp page_title(:edit), do: "Edit Message"
end
