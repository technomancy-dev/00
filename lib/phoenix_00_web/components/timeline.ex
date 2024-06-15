defmodule Timeline do
  alias Phoenix00Web.CoreComponents
  alias Timex
  # In Phoenix apps, the line is typically: use MyAppWeb, :html
  use Phoenix.Component

  def view(assigns) do
    ~H"""
    <ul class="timeline">
      <li :for={row <- @rows}>
        <hr />
        <div class="timeline-start text-xs">
          <%= Timex.format!(row.inserted_at, "%b %d,  %H:%M%P", :strftime) %>
        </div>
        <div class="timeline-middle">
          <CoreComponents.icon name="hero-check-circle" class="h-5 w-5" />
        </div>
        <div class="timeline-end timeline-box capitalize">
          <span
            data-status={row.status}
            class="text-gray-500 data-[status='delivered']:text-success data-[status='bounced']:text-warning data-[status='complained']:text-error"
          >
            <%= row.status %>
          </span>
        </div>
        <hr />
      </li>
    </ul>
    """
  end

  def compact(assigns) do
    ~H"""
    <div class="flex flex-col place-items-center">
      <div class="timeline-start text-xs">
        <%= @destination %>
      </div>
      <ul class="timeline flex">
        <li :for={row <- @rows}>
          <hr />
          <div class="timeline-start -mb-6 mx-2 z-10 timeline-box">
            <CoreComponents.icon
              name={
                case row.status do
                  "delivered" -> "hero-check-circle text-success"
                  "sent" -> "hero-paper-airplane"
                  "bounced" -> "hero-exclamation-circle text-warning"
                  "complained" -> "hero-exclamation-triangle text-error"
                end
              }
              class="h-5 w-5"
            />
          </div>
          <hr />
        </li>
      </ul>
    </div>
    """
  end
end
