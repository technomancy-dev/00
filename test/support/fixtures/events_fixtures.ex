defmodule Phoenix00.EventsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Phoenix00.Events` context.
  """

  @doc """
  Generate a event.
  """
  def event_fixture(attrs \\ %{}) do
    {:ok, event} =
      attrs
      |> Enum.into(%{
        status: "some status"
      })
      |> Phoenix00.Events.create_event()

    event
  end
end
