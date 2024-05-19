defmodule Phoenix00Web.EmailJSON do
  alias Phoenix00.Messages.Email

  def index(%{email: email}) do
    %{data: data(email)}
  end

  def index(json) do
    %{data: data(json)}
  end

  def send(%{email: email}) do
    %{data: data(email)}
  end

  defp data(_json) do
    %{success: true}
  end
end
