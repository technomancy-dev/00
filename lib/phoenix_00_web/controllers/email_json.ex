defmodule Phoenix00Web.EmailJSON do
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
    %{success: true, message: "Your email has successfully been queued."}
  end
end
