defmodule Phoenix00.MailMan do
  require Phoenix.Component

  import Phoenix.HTML

  def letter(%{to: _to, from: _from, subject: _subject, html: html, text: text} = email) do
    Map.merge(email, %{"html_body" => html, "text_body" => text})
  end

  def letter(%{to: _to, from: _from, subject: _subject, html: html} = email) do
    Map.merge(email, %{
      "html_body" => html,
      "text_body" => html |> html_escape() |> safe_to_string()
    })
  end

  def letter(%{to: _to, from: _from, subject: _subject, markdown: markdown} = email) do
    html = render_markdown_to_html(markdown)

    Map.merge(email, %{
      "html_body" => html,
      "text_body" => html |> html_escape() |> safe_to_string()
    })
  end

  def enqueue_worker(email) do
    %{email: email}
    |> Phoenix00.Workers.SendEmail.new()
    |> Oban.insert()
  end

  defp render_markdown_to_html(markdown) do
    MDEx.to_html(markdown)
  end
end
