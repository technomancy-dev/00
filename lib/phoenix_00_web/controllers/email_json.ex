defmodule Phoenix00Web.EmailJSON do
  alias Phoenix00.Messages.Email

  def index(%{email: email}) do
    %{data: data(email)}
  end

  def send(%{email: email}) do
    %{data: data(email)}
  end

  defp data(email) do
    email
  end
end
