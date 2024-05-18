defmodule Phoenix00Web.EmailController do
  alias Phoenix00.Messages
  use Phoenix00Web, :controller

  def send(
        conn,
        %{"from" => _from, "to" => _to, "subject" => _subject, "body" => _body, "text" => _text} =
          email
      ) do
    email |> Messages.send_email()

    render(conn, :index, email: email)
  end
end
