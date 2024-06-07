defmodule Phoenix00.Mailer do
  use Swoosh.Mailer, otp_app: :phoenix_00

  def to_map(%Swoosh.Email{} = email) do
    %{
      "to" => contact_to_map(email.to),
      "from" => contact_to_map(email.from),
      "subject" => email.subject,
      "text_body" => email.text_body,
      "html_body" => email.html_body
    }
  end

  def from_map(args) do
    %{
      "to" => to,
      "from" => from,
      "subject" => subject,
      "text_body" => text_body,
      "html_body" => html_body
    } = args

    opts = [
      to: map_to_contact(to),
      from: map_to_contact(from),
      subject: subject,
      text_body: text_body,
      html_body: html_body
    ]

    Swoosh.Email.new(opts)
  end

  defp contact_to_map(info) when is_list(info) do
    Enum.map(info, &contact_to_map/1)
  end

  defp contact_to_map({name, email}) do
    %{"name" => name, "email" => email}
  end

  defp map_to_contact(info) when is_list(info) do
    Enum.map(info, &map_to_contact/1)
  end

  defp map_to_contact(info) when is_bitstring(info) do
    {nil, info}
  end

  defp map_to_contact(%{"name" => name, "email" => email}) do
    {name, email}
  end
end
