defmodule Phoenix00.ContactsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Phoenix00.Contacts` context.
  """

  @doc """
  Generate a recipient.
  """
  def recipient_fixture(attrs \\ %{}) do
    {:ok, recipient} =
      attrs
      |> Enum.into(%{
        destination: "some destination"
      })
      |> Phoenix00.Contacts.create_recipient()

    recipient
  end
end
