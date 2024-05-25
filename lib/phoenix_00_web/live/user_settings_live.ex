defmodule Phoenix00Web.UserSettingsLive do
  use Phoenix00Web, :live_view

  alias Phoenix00.Accounts

  def render(assigns) do
    ~H"""
    <.header class="text-center">
      Account Settings
      <:subtitle>Manage your account email address, API keys, and password settings</:subtitle>
    </.header>
    <div class="space-y-12 divide-base-200">
      <div>
        <p class="text-center">
          Before you can get started you will need an API key.
        </p>
        <.simple_form
          for={@token_form}
          class="float-right"
          id="token_form"
          phx-submit="generate_api_key"
        >
          <:actions>
            <.button class="btn-wide" phx-disable-with="Changing...">Create New Key</.button>
          </:actions>
        </.simple_form>
        <.table id="emails" rows={@streams.api_keys}>
          <:col :let={{_id, key}} label="Created at">
            <span>
              <%= key.created_at %>
            </span>
          </:col>
          <:action :let={{id, key}}>
            <.link
              phx-click={JS.push("delete_api_key", value: %{id: key.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
            >
              Delete
            </.link>
          </:action>
        </.table>
      </div>
      <div class="mx-auto">
        <.simple_form
          for={@email_form}
          class="max-w-lg mx-auto"
          id="email_form"
          phx-submit="update_email"
          phx-change="validate_email"
        >
          <.input field={@email_form[:email]} type="email" label="Email" required />
          <.input
            field={@email_form[:current_password]}
            name="current_password"
            id="current_password_for_email"
            type="password"
            label="Current password"
            value={@email_form_current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Email</.button>
          </:actions>
        </.simple_form>
      </div>
      <div>
        <.simple_form
          for={@password_form}
          id="password_form"
          class="max-w-lg mx-auto"
          action={~p"/users/log_in?_action=password_updated"}
          method="post"
          phx-change="validate_password"
          phx-submit="update_password"
          phx-trigger-action={@trigger_submit}
        >
          <input
            name={@password_form[:email].name}
            type="hidden"
            id="hidden_user_email"
            value={@current_email}
          />
          <.input field={@password_form[:password]} type="password" label="New password" required />
          <.input
            field={@password_form[:password_confirmation]}
            type="password"
            label="Confirm new password"
          />
          <.input
            field={@password_form[:current_password]}
            name="current_password"
            type="password"
            label="Current password"
            id="current_password_for_password"
            value={@current_password}
            required
          />
          <:actions>
            <.button phx-disable-with="Changing...">Change Password</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    <.modal :if={@token} id="email-modal" show on_cancel={JS.navigate(~p"/users/settings")}>
      <div>
        <p class="p-2 text-center">
          We will only show this once, please copy it and treat it like a password.
        </p>
        <p class="w-full p-10 text-center bg-base-200"><%= @token %></p>
      </div>
    </.modal>
    """
  end

  def mount(%{"token" => token}, _session, socket) do
    socket =
      case Accounts.update_user_email(socket.assigns.current_user, token) do
        :ok ->
          put_flash(socket, :info, "Email changed successfully.")

        :error ->
          put_flash(socket, :error, "Email change link is invalid or it has expired.")
      end

    {:ok, push_navigate(socket, to: ~p"/users/settings")}
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_user
    email_changeset = Accounts.change_user_email(user)
    password_changeset = Accounts.change_user_password(user)

    socket =
      socket
      |> assign(:current_password, nil)
      |> assign(:email_form_current_password, nil)
      |> assign(:current_email, user.email)
      |> assign(:email_form, to_form(email_changeset))
      |> assign(:password_form, to_form(password_changeset))
      |> assign(:token_form, to_form(%{}))
      |> assign(:token, false)
      |> assign(:trigger_submit, false)

    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, _params) do
    user = socket.assigns.current_user
    user_api_keys = Accounts.fetch_user_api_tokens(user)

    tokens =
      Enum.map(user_api_keys, fn key ->
        %{id: key.id, created_at: key.inserted_at}
      end)

    socket
    |> stream(:api_keys, tokens)
  end

  def handle_event("delete_api_key", %{"id" => id}, socket) do
    key = Accounts.fetch_user_api_key_by_id(id)
    Accounts.delete_api_key(key)

    {:noreply, stream_delete(socket, :api_keys, %{id: key.id, created_at: key.inserted_at})}
  end

  def handle_event("validate_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    email_form =
      socket.assigns.current_user
      |> Accounts.change_user_email(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, email_form: email_form, email_form_current_password: password)}
  end

  def handle_event("update_email", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.apply_user_email(user, password, user_params) do
      {:ok, applied_user} ->
        Accounts.deliver_user_update_email_instructions(
          applied_user,
          user.email,
          &url(~p"/users/settings/confirm_email/#{&1}")
        )

        info = "A link to confirm your email change has been sent to the new address."
        {:noreply, socket |> put_flash(:info, info) |> assign(email_form_current_password: nil)}

      {:error, changeset} ->
        {:noreply, assign(socket, :email_form, to_form(Map.put(changeset, :action, :insert)))}
    end
  end

  def handle_event("validate_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params

    password_form =
      socket.assigns.current_user
      |> Accounts.change_user_password(user_params)
      |> Map.put(:action, :validate)
      |> to_form()

    {:noreply, assign(socket, password_form: password_form, current_password: password)}
  end

  def handle_event("update_password", params, socket) do
    %{"current_password" => password, "user" => user_params} = params
    user = socket.assigns.current_user

    case Accounts.update_user_password(user, password, user_params) do
      {:ok, user} ->
        password_form =
          user
          |> Accounts.change_user_password(user_params)
          |> to_form()

        {:noreply, assign(socket, trigger_submit: true, password_form: password_form)}

      {:error, changeset} ->
        {:noreply, assign(socket, password_form: to_form(changeset))}
    end
  end

  def handle_event("generate_api_key", _params, socket) do
    user = socket.assigns.current_user

    case Accounts.fetch_new_api_token(user) do
      {:ok, token} ->
        {:noreply, assign(socket, token: token)}
    end
  end
end
