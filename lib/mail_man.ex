defmodule Phoenix00.MailMan do
  alias Phoenix00.Templates
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

  def fill_template(email, contact) do
    replace_body_with_rendered_template(email, contact)
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


    render = MDEx.to_html(markdown)

    """
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"><html lang="en" dir="ltr"><head><style tailwind>/* layer: preflights */
    /* layer: default */
    .mx-auto{margin-left:auto;margin-right:auto;}
    .max-w-md{max-width:600px;}
    .bg-white{background-color:rgb(255,255,255);}
    .p-16{padding:64px;}
    .text-slate-700{color:rgb(51,65,85);}
    .font-sans{font-family:ui-sans-serif,system-ui,-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Helvetica Neue",Arial,"Noto Sans",sans-serif,"Apple Color Emoji","Segoe UI Emoji","Segoe UI Symbol","Noto Color Emoji";}</style></head><body><div class="bg-white text-slate-700"><div class="font-sans bg-white max-w-md mx-auto"><div style="padding:12px">
    <p>#{render}</p>
    </div></div></div></body></html>
    """
  end

  defp render_html_to_plain_text(html) do
    case Pandex.html_to_plain(html) do
      {:ok, plain} -> plain
      error -> error
    end
  end

  defp replace_body_with_rendered_template(%{"markdown" => markdown} = email, contact) do
    Map.merge(email, %{"markdown" => Templates.render_template(markdown, %{"contact" => contact})})
  end

  defp replace_body_with_rendered_template(%{"html" => html} = email, contact) do
    Map.merge(email, %{"html" => Templates.render_template(html, %{"contact" => contact})})
  end
end
