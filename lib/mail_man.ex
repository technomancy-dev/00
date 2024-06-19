defmodule Phoenix00.MailMan do
  alias Phoenix00.Messages
  alias Phoenix00.Mailer

  require Phoenix.Component



  def letter(email) do
    email_map = make_map(email)

    with {:ok, _map} <- Mailer.from_map(email_map) do
      {:ok, email_record} = save_email_record(email_map)
      email_with_id = Map.merge(email_map, %{"id" => email_record.id})
      {:ok, email_with_id}
    else
      {:error, _error} = error_tuple -> error_tuple
    end
  end

  def make_map(
        %{"to" => _to, "from" => _from, "subject" => _subject, "html" => html, "text" => text} =
          email
      ) do

    Map.merge(email, %{"html_body" => html, "text_body" => text})
  end

  def make_map(%{"to" => _to, "from" => _from, "subject" => _subject, "html" => html} = email) do

    Map.merge(email, %{
      "html_body" => html,
      "text_body" => html |> render_html_to_plain_text()
    })
  end

  def make_map(
        %{"to" => _to, "from" => _from, "subject" => _subject, "markdown" => markdown} = email
      ) do
    html = render_markdown_to_html(markdown)

    Map.merge(email, %{
      "html_body" => html,
      "text_body" => html |> render_html_to_plain_text()
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


  defp render_html_to_plain_text(html) do
    case Pandex.html_to_plain(html) do
      {:ok, plain} -> plain
      error -> error
    end
  end

end
