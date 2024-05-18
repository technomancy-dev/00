defmodule Phoenix00Web.ErrorJSONTest do
  use Phoenix00Web.ConnCase, async: true

  test "renders 404" do
    assert Phoenix00Web.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Phoenix00Web.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
