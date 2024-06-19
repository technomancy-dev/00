defmodule Phoenix00Web.EmailLive.Show do
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
     |> assign(:email, Messages.get_email!(id))}
  end

  defp page_title(:show), do: "Show Email"
  defp page_title(:edit), do: "Edit Email"

  defp sort_events(events) do
    order = ["pending", "sent", "delivered", "bounced", "complained"]
    order_idx = order |> Enum.zip(1..5) |> Map.new()
    Enum.sort_by(events, &order_idx[&1.status])
  end
end
