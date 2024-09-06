defmodule NotificationProxyWeb.ErrorJSONTest do
  use NotificationProxyWeb.ConnCase, async: true

  test "renders 404" do
    assert NotificationProxyWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert NotificationProxyWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
