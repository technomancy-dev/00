defmodule App.StatusMachine do
  defstruct [:state]

  use Fsmx.Struct,
    transitions: %{
      "pending" => :*,
      "sent" => ["complaint", "bounced", "delivered"],
      :* => ["bounced", "complaint"]
    }

  def get_status_from_event_type(event_type) do
    case event_type do
      "Bounce" -> "bounced"
      "Complaint" -> "complained"
      "Send" -> "sent"
      "Pending" -> "pending"
      "Delivery" -> "delivered"
    end
  end
end
