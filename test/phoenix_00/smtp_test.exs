defmodule SmtpTest do
  use Phoenix00.DataCase

  alias Pique.Smtp

  test "returns an :ok if both handler and sender pass" do
    Application.put_env(:pique, :data_handler, Phoenix00.MailHander)
    Application.put_env(:pique, :sender, Phoenix00.SESSender)

    assert Smtp.handle_DATA(
             "foo",
             "bar",
             "From: \"Sender Name\" <sender@example.com>\r\nTo: \"Recipient Name\" <recipient@example.com>\r\nCc: cc@example.com\r\nBcc: bcc@example.com\r\nSubject: Test Email\r\nDate: Tue, 22 Oct 2024 10:00:00 -0700\r\nMessage-ID: <unique-identifier@yourdomain.com>\r\nMIME-Version: 1.0\r\nContent-Type: text/plain; charset=\"UTF-8\"\r\nSubject: Test Email\r\n\r\nThis is a test email sent via SMTP commands.",
             %{from: "sender@example.com", rcpt: ["recipient@example.com"]}
           ) == {
             :ok,
             nil,
             %{
               body:
                 "From: \"Sender Name\" <sender@example.com>\r\nTo: \"Recipient Name\" <recipient@example.com>\r\nCc: cc@example.com\r\nBcc: bcc@example.com\r\nSubject: Test Email\r\nDate: Tue, 22 Oct 2024 10:00:00 -0700\r\nMessage-ID: <unique-identifier@yourdomain.com>\r\nMIME-Version: 1.0\r\nContent-Type: text/plain; charset=\"UTF-8\"\r\nSubject: Test Email\r\n\r\nThis is a test email sent via SMTP commands.",
               from: "sender@example.com",
               rcpt: ["recipient@example.com"]
             }
           }

    Application.delete_env(:pique, :data_handler)
    Application.delete_env(:pique, :sender)
  end
end
