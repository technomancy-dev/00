defmodule Phoenix00.LogsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Phoenix00.Logs` context.
  """

  @doc """
  Generate a log.
  """
  def log_fixture(attrs \\ %{}) do
    {:ok, log} =
      attrs
      |> Enum.into(%{
        endpoint: "some endpoint",
        ke_name: "some ke_name",
        method: :get,
        request: %{},
        response: %{},
        status: 42
      })
      |> Phoenix00.Logs.create_log()

    log
  end
end
