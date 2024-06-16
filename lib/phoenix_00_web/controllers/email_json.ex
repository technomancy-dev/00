defmodule Phoenix00Web.EmailJSON do
  # alias Phoenix00.Logs

  def index(%{data: data}) do
    %{data: data}
  end

  # def send(%{email: email, token: token}) do
  #   %{data: data(email, token)}
  # end

  # defp data(email, token) do
  #   response = %{success: true, message: "Your email has successfully been queued."}

  #   Logs.create_log(%{
  #     status: 200,
  #     endpoint: "/api/emails",
  #     method: :post,
  #     request: email,
  #     response: response,
  #     token_id: token.id
  #   })

  #   response
  # end
end
