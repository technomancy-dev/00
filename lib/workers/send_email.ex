defmodule Phoenix00.Workers.SendEmail do
  use Oban.Worker, queue: :mailer

  alias Phoenix00.Mailer

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"email" => email_args}}) do
    with email <- Mailer.from_map(email_args),
         {:ok, _metadata} <- Mailer.deliver(email) do
      :ok
    end
  end
end
