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
      <%!-- <li>
        <hr />
        <div class="timeline-start">1998</div>
        <div class="timeline-middle">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5"
          >
            <path
              fill-rule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
        <div class="timeline-end timeline-box">iMac</div>
        <hr />
      </li>
      <li>
        <hr />
        <div class="timeline-start">2001</div>
        <div class="timeline-middle">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5"
          >
            <path
              fill-rule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
        <div class="timeline-end timeline-box">iPod</div>
        <hr />
      </li>
      <li>
        <hr />
        <div class="timeline-start">2007</div>
        <div class="timeline-middle">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5"
          >
            <path
              fill-rule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
        <div class="timeline-end timeline-box">iPhone</div>
        <hr />
      </li>
      <li>
        <hr />
        <div class="timeline-start">2015</div>
        <div class="timeline-middle">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 20 20"
            fill="currentColor"
            class="w-5 h-5"
          >
            <path
              fill-rule="evenodd"
              d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.857-9.809a.75.75 0 00-1.214-.882l-3.483 4.79-1.88-1.88a.75.75 0 10-1.06 1.061l2.5 2.5a.75.75 0 001.137-.089l4-5.5z"
              clip-rule="evenodd"
            />
          </svg>
        </div>
        <div class="timeline-end timeline-box">Apple Watch</div>
      </li> --%>
    </ul>
    """
  end
end
