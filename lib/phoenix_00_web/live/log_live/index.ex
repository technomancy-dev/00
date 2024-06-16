defmodule Phoenix00Web.LogLive.Index do
  alias Phoenix00.Accounts
  use Phoenix00Web, :live_view

  alias Phoenix00.Logs
  alias Phoenix00.Logs.Log

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :logs, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Log")
    |> assign(:log, Logs.get_log!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Log")
    |> assign(:log, %Log{})
  end

  defp apply_action(socket, :index, params) do
    user = socket.assigns.current_user

    user_api_keys =
      Enum.map(Accounts.fetch_user_api_tokens(user), fn token -> {token.name, token.id} end)

    IO.inspect(user_api_keys)

    case Logs.list_logs_flop(params) do
      {:ok, {logs, meta}} ->
        socket
        |> assign(:page_title, "Listing Logs")
        |> assign(:form, Phoenix.Component.to_form(meta))
        |> assign(:tokens, user_api_keys)
        |> stream(
          :logs,
          logs,
          reset: true
        )
        |> assign(:meta, meta)
        |> assign(:log, nil)
    end
  end

  @impl true
  def handle_info({Phoenix00Web.LogLive.FormComponent, {:saved, log}}, socket) do
    {:noreply, stream_insert(socket, :logs, log)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    log = Logs.get_log!(id)
    {:ok, _} = Logs.delete_log(log)

    {:noreply, stream_delete(socket, :logs, log)}
  end

  def handle_event("update_filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/logs?#{params}")}
  end
end
