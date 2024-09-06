defmodule NotificationProxyWeb.ShopifyControllerTest do
  use NotificationProxyWeb.ConnCase

  import NotificationProxy.NotificationsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  describe "index" do
    test "lists all shopify_notifications", %{conn: conn} do
      conn = get(conn, ~p"/shopify_notifications")
      assert html_response(conn, 200) =~ "Listing Shopify notifications"
    end
  end

  describe "new shopify" do
    test "renders form", %{conn: conn} do
      conn = get(conn, ~p"/shopify_notifications/new")
      assert html_response(conn, 200) =~ "New Shopify"
    end
  end

  describe "create shopify" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/shopify_notifications", shopify: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == ~p"/shopify_notifications/#{id}"

      conn = get(conn, ~p"/shopify_notifications/#{id}")
      assert html_response(conn, 200) =~ "Shopify #{id}"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/shopify_notifications", shopify: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Shopify"
    end
  end

  describe "edit shopify" do
    setup [:create_shopify]

    test "renders form for editing chosen shopify", %{conn: conn, shopify: shopify} do
      conn = get(conn, ~p"/shopify_notifications/#{shopify}/edit")
      assert html_response(conn, 200) =~ "Edit Shopify"
    end
  end

  describe "update shopify" do
    setup [:create_shopify]

    test "redirects when data is valid", %{conn: conn, shopify: shopify} do
      conn = put(conn, ~p"/shopify_notifications/#{shopify}", shopify: @update_attrs)
      assert redirected_to(conn) == ~p"/shopify_notifications/#{shopify}"

      conn = get(conn, ~p"/shopify_notifications/#{shopify}")
      assert html_response(conn, 200)
    end

    test "renders errors when data is invalid", %{conn: conn, shopify: shopify} do
      conn = put(conn, ~p"/shopify_notifications/#{shopify}", shopify: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Shopify"
    end
  end

  describe "delete shopify" do
    setup [:create_shopify]

    test "deletes chosen shopify", %{conn: conn, shopify: shopify} do
      conn = delete(conn, ~p"/shopify_notifications/#{shopify}")
      assert redirected_to(conn) == ~p"/shopify_notifications"

      assert_error_sent 404, fn ->
        get(conn, ~p"/shopify_notifications/#{shopify}")
      end
    end
  end

  defp create_shopify(_) do
    shopify = shopify_fixture()
    %{shopify: shopify}
  end
end
