defmodule Phoenix00.Messages do
  alias Phoenix00.Messages.EmailRepo
  alias Phoenix00.Messages.Services

  def send_email(email_req) do
    Services.SendEmail.call(email_req)
  end

  def recieve_sns(sns) do
    Services.RecieveSns.call(sns)
  end

  defdelegate list_emails(limit, offset), to: EmailRepo
  defdelegate get_email!(id), to: EmailRepo
  defdelegate email_count(), to: EmailRepo
  defdelegate change_email(attrs), to: EmailRepo
  defdelegate change_email(email, attrs), to: EmailRepo
  defdelegate create_email(attrs), to: EmailRepo
  defdelegate update_email(email), to: EmailRepo
  defdelegate update_email(email, attr), to: EmailRepo
  defdelegate delete_email(email), to: EmailRepo
end
