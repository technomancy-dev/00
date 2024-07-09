defmodule Phoenix00.Templates do
  def render_template(template, variables) do
    with {:ok, parsed} <- Solid.parse(template),
         {:ok, rendered} <- Solid.render(parsed, variables) do
      rendered |> to_string
    end
  end
end
