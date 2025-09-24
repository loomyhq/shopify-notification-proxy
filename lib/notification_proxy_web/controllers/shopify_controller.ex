defmodule NotificationProxyWeb.ShopifyController do
  use NotificationProxyWeb, :controller

  def create(conn, params) do
    url = Application.get_env(:notification_proxy, :slack_hook)
    total = get_in(params, ["current_subtotal_price_set", "shop_money", "amount"])
    firstname = get_in(params, ["customer", "first_name"])
    lastname = get_in(params, ["customer", "last_name"])

    discount_codes = get_in(params, ["discount_codes"])

    message = "#{firstname} #{lastname} heeft een bestelling geplaatst voor €#{total} 🥳"

    discounts =
      case discount_codes do
        nil ->
          ""

        [] ->
          ""

        dcs ->
          codes = Enum.map(dcs, fn dc -> get_in(dc, ["code"]) end)
          " Kortingscodes: #{Enum.join(codes, ", ")}"
      end

    params = %{
      text: message <> discounts
    }

    HTTPoison.post(url, Jason.encode!(params), [{"Content-Type", "application/json"}])
    text(conn, "ok")
  end
end
