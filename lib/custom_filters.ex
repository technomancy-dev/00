defmodule CustomFilters do
  import Ecto.Query
  # Modified from https://hexdocs.pm/flop/Flop.Schema.html#module-custom-fields
  # TODO: Maybe use browser local time if SQLite supports passing timezone.
  def date_range(query, %Flop.Filter{value: value, op: _op}, opts) do
    source = Keyword.fetch!(opts, :source)

    expr =
      dynamic(
        [r],
        fragment("date(?, ?)", field(r, ^source), ^value)
      )

    date = Date.utc_today()
    conditions = dynamic([r], ^expr >= ^date)

    where(query, ^conditions)
  end
end
