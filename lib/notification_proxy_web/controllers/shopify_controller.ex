defmodule NotificationProxyWeb.ShopifyController do
  use NotificationProxyWeb, :controller

  @url Application.compile_env(:notification_proxy, :slack_hook)

  def create(conn, params) do
    total = get_in(params, ["current_subtotal_price_set", "shop_money", "amount"])
    firstname = get_in(params, ["customer", "first_name"])
    lastname = get_in(params, ["customer", "last_name"])

    params = %{
      text: "#{firstname} #{lastname} heeft een bestelling geplaatst voor €#{total} 🥳"
    }

    HTTPoison.post(@url, Jason.encode!(params), [{"Content-Type", "application/json"}])
  end
end
