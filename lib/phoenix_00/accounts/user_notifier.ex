defmodule Phoenix00.Accounts.UserNotifier do
  alias Phoenix00.Messages

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    with :ok <-
           Messages.send_email(%{
             "from" => "00 <#{System.get_env("SYSTEM_EMAIL")}>",
             "to" => recipient,
             "subject" => subject,
             "markdown" => body
           }) do
      {:ok, %{}}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(user, url) do
    deliver(user.email, "Confirmation instructions", """
    # Hi #{user.email},

    You can confirm your account by visiting the URL below:

    [confirm email](#{url})

    If you didn't create an account with us, **please ignore this.**
    """)
  end

  @doc """
  Deliver instructions to reset a user password.
  """
  def deliver_reset_password_instructions(user, url) do
    deliver(user.email, "Reset password instructions", """

    ==============================

    Hi #{user.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a user email.
  """
  def deliver_update_email_instructions(user, url) do
    deliver(user.email, "Update email instructions", """

    ==============================

    Hi #{user.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
