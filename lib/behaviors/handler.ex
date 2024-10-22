defmodule Phoenix00.MailHander do
  @behaviour Pique.Behaviours.Handler

  # Example of how to block a certain email address.
  # def handle("nefarious.fellow@canada.org"), do: {:error, "Go away nefarious fellow"}
  def handle(email), do: {:ok, email}

end
