defmodule Phoenix00Web.UserLoginLive do
  alias Phoenix00.Accounts
  use Phoenix00Web, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm h-full place-items-center flex">
      <div class="mx-auto max-w-sm">
        <.header class="text-center">
          Log in to your <span class="underline text-warning">single</span>
          account
          <:subtitle>
            If you need more than one account please<br />
            <a
              class="text-success capitalize underline font-bold"
              href="https://buy.stripe.com/5kA3dV5W1aBgaUo28e?prefilled_promo_code=KOOKIES"
            >
              upgrade to pro.
            </a>
          </:subtitle>
        </.header>

        <.simple_form for={@form} id="login_form" action={~p"/users/log_in"} phx-update="ignore">
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
            <.link href={~p"/users/reset_password"} class="text-sm font-semibold">
              Forgot your password?
            </.link>
          </:actions>
          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full">
              Log in <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    case Accounts.user_exists?() do
      true ->
        email = Phoenix.Flash.get(socket.assigns.flash, :email)
        form = to_form(%{"email" => email}, as: "user")
        {:ok, assign(socket, form: form), temporary_assigns: [form: form]}

      false ->
        {:ok, push_redirect(socket, to: ~p"/users/register")}
    end
  end
end
