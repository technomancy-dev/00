defmodule Phoenix00Web.UserRegistrationLive do
  use Phoenix00Web, :live_view

  alias Phoenix00.Accounts
  alias Phoenix00.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm h-full place-items-center flex">
      <div class="w-full">
        <.header class="text-center">
          Register your <span class="underline text-warning">single</span>
          account.
          <:subtitle>
            If you need more than one account please<br />
            <a
              class="text-success capitalize underline font-bold"
              href="https://buy.stripe.com/5kA3dV5W1aBgaUo28e?prefilled_promo_code=KOOKIES"
            >
              upgrade to pro.
            </a>
          </:subtitle>
          <%!-- <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Log in
          </.link>
          to your account now.
        </:subtitle> --%>
        </.header>

        <.simple_form
          for={@form}
          id="registration_form"
          phx-submit="save"
          phx-change="validate"
          phx-trigger-action={@trigger_submit}
          action={~p"/users/log_in?_action=registered"}
          method="post"
        >
          <.error :if={@check_errors}>
            Oops, something went wrong! Please check the errors below.
          </.error>

          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    case Accounts.user_exists?() do
      true ->
        {:ok, push_redirect(socket, to: ~p"/users/log_in")}

      false ->
        socket =
          socket
          |> assign(trigger_submit: false, check_errors: false)
          |> assign_form(changeset)

        {:ok, socket, temporary_assigns: [form: nil]}
    end
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
