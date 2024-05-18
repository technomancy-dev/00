defmodule Phoenix00.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Phoenix00.Messages` context.
  """

  @doc """
  Generate a unique email email_id.
  """
  def unique_email_email_id, do: "some email_id#{System.unique_integer([:positive])}"

  @doc """
  Generate a email.
  """
  def email_fixture(attrs \\ %{}) do
    {:ok, email} =
      attrs
      |> Enum.into(%{
        aws_message_id: "some aws_message_id",
        email_id: unique_email_email_id(),
        from: "some from",
        status: :pending,
        to: "some to"
      })
      |> Phoenix00.Messages.create_email()

    email
  end
end
