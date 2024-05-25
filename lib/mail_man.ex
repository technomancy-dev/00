defmodule Phoenix00.MailMan do
  require Phoenix.Component
  import Swoosh.Email
  import Phoenix.HTML

  def letter(%{to: to, from: from, subject: subject, body: body, text: text}) do
    new()
    |> to({nil, to})
    |> from({nil, from})
    |> subject(subject)
    |> html_body(body)
    |> text_body(text)
    |> put_provider_option(:configuration_set_name, "default")
  end

  def letter(%{to: to, from: from, subject: subject, markdown: markdown}) do
    html = render_markdown_to_html(markdown)

    new()
    |> to({nil, to})
    |> from({nil, from})
    |> subject(subject)
    |> html_body(html)
    |> text_body(html |> html_escape() |> safe_to_string())
    |> put_provider_option(:configuration_set_name, "default")
  end

  def enqueue_worker(email) do
    email_map = Phoenix00.Mailer.to_map(email)

    %{email: email_map}
    |> Phoenix00.Workers.SendEmail.new()
    |> Oban.insert()
  end

  # defp render_markdown(markdown) do
  #   %{html: render_markdown_to_html(markdown)}
  # end

  defp render_markdown_to_html(markdown) do
    MDEx.to_html(markdown)
  end
end
