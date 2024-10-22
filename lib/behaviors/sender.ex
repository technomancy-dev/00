defmodule Phoenix00.SESSender do
  @behaviour Pique.Behaviours.Sender
  alias Phoenix00.Messages


  def send(state) do

    smtp_to_zero_request(state)
    |> Messages.send_email()

    {:ok, state[:data], state}
  end

  defp smtp_to_zero_request(data) do
    parsed_email = parse_email(data)

    %{
      "to" => get_to_recipients(parsed_email),
      "cc" => Map.get(parsed_email.headers, "Cc"),
      "bcc" => Map.get(parsed_email.headers, "Bcc"),
      "from" => parsed_email.from,
      "subject" => Map.get(parsed_email.headers, "Subject"),
      "html" => parsed_email.body
    }
  end

  defp parse_email(email_data) do
    {headers, body} = split_headers_and_body(email_data.body)
    parsed_headers = parse_headers(headers)

    %{
      headers: parsed_headers,
      body: String.trim(body),
      from: email_data.from,
      rcpt: email_data.rcpt
    }
  end

  defp get_to_recipients(parsed_email) do
    case Map.get(parsed_email.headers, "To") do
      # Fallback to first RCPT TO
      nil -> List.first(parsed_email.rcpt)
      to -> to
    end
  end

  defp split_headers_and_body(content) do
    case Regex.split(~r/\r\n\r\n|\n\n/, content, parts: 2) do
      [headers, body] -> {headers, body}
      # Assume it's all body if no clear separation
      [only_content] -> {"", only_content}
    end
  end

  defp parse_headers(headers_str) do
    headers_str
    # Split on newlines not followed by whitespace
    |> String.split(~r/\r\n(?=[^\s])/s)
    |> Enum.reduce(%{}, fn header_line, acc ->
      case String.split(header_line, ":", parts: 2) do
        [key, value] ->
          Map.put(acc, String.trim(key), String.trim(value))

        _ ->
          acc
      end
    end)
  end
end
