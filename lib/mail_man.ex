defmodule Phoenix00.MailMan do
  import Swoosh.Email

  def letter(to, from, subject, body, text) do
    new()
    |> to({nil, to})
    |> from({nil, from})
    |> subject(subject)
    |> html_body(body)
    |> text_body(text)
    |> put_provider_option(:configuration_set_name, "default")
  end
end
