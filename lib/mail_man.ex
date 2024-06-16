defmodule Phoenix00.MailMan do
  alias Phoenix00.Messages
  require Phoenix.Component

  import Phoenix.HTML

  def letter!(email) do
    email_map = make_map(email)
    {:ok, email_record} = save_email_record(email_map)
    email_with_id = Map.merge(email_map, %{"id" => email_record.id})
    {:ok, email_with_id}
  end

  def make_map(
        %{"to" => _to, "from" => _from, "subject" => _subject, "html" => html, "text" => text} =
          email
      ) do
    # CREATE_EMAIL_RECORD AND PASS ALONG ID
    Map.merge(email, %{"html_body" => html, "text_body" => text})
  end

  def make_map(%{"to" => _to, "from" => _from, "subject" => _subject, "html" => html} = email) do
    # CREATE_EMAIL_RECORD AND PASS ALONG ID
    Map.merge(email, %{
      "html_body" => html,
      "text_body" => html |> html_escape() |> safe_to_string()
    })
  end

  def make_map(
        %{"to" => _to, "from" => _from, "subject" => _subject, "markdown" => markdown} = email
      ) do
    html = render_markdown_to_html(markdown)
    # CREATE_EMAIL_RECORD AND PASS ALONG ID
    Map.merge(email, %{
      "html_body" => html,
      "text_body" => html |> html_escape() |> safe_to_string()
    })
  end

  def send_letter(email) do
    # Email will be record with ID already.
    %{email: email}
    |> Phoenix00.Workers.SendEmail.new()
    |> Oban.insert()
  end

  def enqueue_worker(email) do
    %{email: email}
    |> Phoenix00.Workers.SendEmail.new()
    |> Oban.insert()
  end

  def add_email_sender(email, sender_id) do
    Messages.add_email_sender(email, sender_id)
  end

  defp save_email_record(email) do
    Messages.create_email(email)
  end

  defp render_markdown_to_html(markdown) do
    MDEx.to_html(markdown)
  end
end
