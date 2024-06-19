defmodule Phoenix00.Mailer do
  use Swoosh.Mailer, otp_app: :phoenix_00

  @defaults %{
    "to" => [],
    "from" => "",
    "subject" => "",
    "bcc" => [],
    "cc" => [],
    "reply_to" => nil,
    "headers" => %{},
    "attachments" => [],
    "provider_options" => %{}
  }

  def from_map(args) do
    %{
      "to" => to,
      "from" => from,
      "subject" => subject,
      "bcc" => bcc,
      "cc" => cc,
      "reply_to" => reply_to,
      "headers" => headers,
      "attachments" => attachments,
      "provider_options" => provider_options,
      "text_body" => text_body,
      "html_body" => html_body
    } = Map.merge(@defaults, args)

    opts =
      Enum.filter(
        [
          to: map_to_contact(to),
          from: map_to_contact(from),
          subject: subject,
          bcc: map_to_contact(bcc),
          cc: map_to_contact(cc),
          reply_to: map_to_contact(reply_to),
          headers: headers,
          provider_options: provider_options,
          text_body: text_body,
          html_body: html_body
        ],
        fn tuple -> elem(tuple, 1) != nil end
      )

    email = Swoosh.Email.new(opts)

    wrap_result(Enum.reduce(attachments, email, &add_attachment/2))
  end

  defp wrap_result({:error, _reason} = error) do
    error
  end

  defp wrap_result(result) do
    {:ok, result}
  end

  defp add_attachment(_attachment, swoosh) when is_tuple(swoosh) do
    swoosh
  end

  defp add_attachment(attachment, %Swoosh.Email{} = swoosh) do
    case attachment["content_type"] do
      nil ->
        {:error, "Missing content type on attachment."}

      content_type ->
        swoosh
        |> Swoosh.Email.attachment(
          Swoosh.Attachment.new({:data, attachment["content"]},
            filename: attachment["filename"],
            content_type: content_type
          )
        )
    end
  end

  defp map_to_contact(info) when is_list(info) do
    Enum.map(info, &map_to_contact/1)
  end

  defp map_to_contact(info) when is_bitstring(info) do
    {nil, info}
  end

  defp map_to_contact(info) when is_nil(info) do
    nil
  end

  defp map_to_contact(%{"name" => name, "email" => email}) do
    {name, email}
  end
end
